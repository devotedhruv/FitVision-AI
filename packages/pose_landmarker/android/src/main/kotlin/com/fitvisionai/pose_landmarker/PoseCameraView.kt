package com.fitvisionai.pose_landmarker

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Handler
import android.os.Looper
import android.util.Size
import android.util.Log
import android.view.View
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.Preview
import androidx.camera.core.resolutionselector.ResolutionSelector
import androidx.camera.core.resolutionselector.ResolutionStrategy
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.view.PreviewView
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import io.flutter.plugin.platform.PlatformView
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class PoseCameraView(
    context: Context,
    private val activity: Activity?,
    initialFrontCamera: Boolean,
    configuration: PoseLandmarkerConfiguration,
    private val eventEmitter: (Map<String, Any?>) -> Unit,
    private val errorEmitter: (String, String) -> Unit,
) : PlatformView {
    private val previewView =
        PreviewView(context).apply {
            implementationMode = PreviewView.ImplementationMode.COMPATIBLE
            scaleType = PreviewView.ScaleType.FILL_CENTER
        }
    private val mainHandler = Handler(Looper.getMainLooper())
    private val analysisExecutor: ExecutorService =
        Executors.newSingleThreadExecutor { runnable ->
            Thread(runnable, "fitvision-pose-analysis").apply { priority = Thread.NORM_PRIORITY }
        }
    private var cameraProvider: ProcessCameraProvider? = null
    private var imageAnalysis: ImageAnalysis? = null
    private var frontCamera = initialFrontCamera
    private var resultCount = 0L
    private val landmarker: PoseLandmarkerHelper?
    private val resourceLifecycle: CameraResourceLifecycle by lazy {
        CameraResourceLifecycle(
            pauseResources = {
                imageAnalysis?.clearAnalyzer()
                cameraProvider?.unbindAll()
            },
            resumeResources = ::startCamera,
            disposeResources = {
                imageAnalysis?.clearAnalyzer()
                cameraProvider?.unbindAll()
                landmarker?.close()
                analysisExecutor.shutdownNow()
            },
        )
    }

    init {
        emitStatus("initializing", "Loading on-device pose model.")
        landmarker =
            try {
                PoseLandmarkerHelper(
                    context = context.applicationContext,
                    configuration = configuration,
                    onResult = { result, metadata ->
                        val helper = landmarker
                        if (resourceLifecycle.isActive && helper != null) {
                            val payload = helper.mappedResult(result, metadata)
                            resultCount += 1
                            if (resultCount % PERFORMANCE_LOG_INTERVAL == 0L) {
                                Log.d(
                                    PERFORMANCE_LOG_TAG,
                                    "fps=${payload["processedFps"]} " +
                                        "latencyMs=${payload["inferenceLatencyMs"]} " +
                                        "dropped=${payload["droppedFrames"]} " +
                                        "status=${payload["status"]}",
                                )
                            }
                            emit(payload)
                        }
                    },
                    onError = ::emitError,
                )
            } catch (error: RuntimeException) {
                emitError("model_error", error.message ?: "Pose model could not be loaded.")
                null
            }
        if (landmarker != null) startCamera()
    }

    override fun getView(): View = previewView

    fun pause() {
        if (resourceLifecycle.pause()) emitStatus("paused", "Pose detection paused.")
    }

    fun resume() {
        resourceLifecycle.resume()
    }

    fun switchCamera() {
        if (resourceLifecycle.isDisposed) return
        frontCamera = !frontCamera
        startCamera()
    }

    private fun startCamera() {
        if (!resourceLifecycle.isActive) return
        val host = activity
        val lifecycleOwner = host as? LifecycleOwner
        if (host == null || lifecycleOwner == null) {
            emitError("camera_error", "A lifecycle-aware Android activity is required.")
            return
        }
        if (
            ContextCompat.checkSelfPermission(host, Manifest.permission.CAMERA) !=
                PackageManager.PERMISSION_GRANTED
        ) {
            emitStatus("permissionDenied", "Camera permission is required.")
            return
        }
        if (!host.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_ANY)) {
            emitError("camera_error", "No camera hardware is available.")
            return
        }
        emitStatus("initializing", "Starting camera.")
        val providerFuture = ProcessCameraProvider.getInstance(host)
        providerFuture.addListener(
            {
                try {
                    if (!resourceLifecycle.isActive) return@addListener
                    val provider = providerFuture.get()
                    cameraProvider = provider
                    bindUseCases(provider, lifecycleOwner)
                } catch (error: Exception) {
                    emitError("camera_error", error.message ?: "Camera initialization failed.")
                }
            },
            ContextCompat.getMainExecutor(host),
        )
    }

    private fun bindUseCases(provider: ProcessCameraProvider, owner: LifecycleOwner) {
        val selector =
            if (frontCamera) CameraSelector.DEFAULT_FRONT_CAMERA else CameraSelector.DEFAULT_BACK_CAMERA
        if (!provider.hasCamera(selector)) {
            emitError("camera_error", "The selected camera is not available.")
            return
        }
        val preview = Preview.Builder().build().also { it.surfaceProvider = previewView.surfaceProvider }
        val resolutionSelector =
            ResolutionSelector.Builder()
                .setResolutionStrategy(
                    ResolutionStrategy(
                        Size(480, 640),
                        ResolutionStrategy.FALLBACK_RULE_CLOSEST_HIGHER_THEN_LOWER,
                    ),
                )
                .build()
        val analysis =
            ImageAnalysis.Builder()
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .setResolutionSelector(resolutionSelector)
                .build()
        val helper = landmarker ?: return
        analysis.setAnalyzer(
            analysisExecutor,
            CameraFrameProcessor(
                frontCamera = { frontCamera },
                landmarker = helper,
                onError = ::emitError,
            ),
        )
        provider.unbindAll()
        provider.bindToLifecycle(owner, selector, preview, analysis)
        imageAnalysis = analysis
        emitStatus("ready", if (frontCamera) "Front camera ready." else "Back camera ready.")
    }

    private fun emitStatus(status: String, message: String) {
        emit(statusPayload(status, message))
    }

    private fun emit(payload: Map<String, Any?>) {
        mainHandler.post {
            if (!resourceLifecycle.isDisposed) eventEmitter(payload)
        }
    }

    private fun emitError(code: String, message: String) {
        mainHandler.post {
            if (!resourceLifecycle.isDisposed) {
                emitStatus(if (code == "model_error") "modelError" else "cameraError", message)
                errorEmitter(code, message)
            }
        }
    }

    override fun dispose() {
        if (resourceLifecycle.dispose()) {
            eventEmitter(statusPayload("disposed", "Camera resources released."))
        }
    }

    private fun statusPayload(status: String, message: String): Map<String, Any?> =
        mapOf(
            "timestamp" to android.os.SystemClock.uptimeMillis(),
            "imageWidth" to 0,
            "imageHeight" to 0,
            "rotation" to 0,
            "lensDirection" to if (frontCamera) "front" else "back",
            "inferenceLatencyMs" to 0.0,
            "poseDetected" to false,
            "status" to status,
            "landmarks" to emptyList<Map<String, Any>>(),
            "worldLandmarks" to emptyList<Map<String, Any>>(),
            "processedFps" to 0.0,
            "droppedFrames" to 0,
            "message" to message,
        )

    companion object {
        private const val PERFORMANCE_LOG_TAG = "FitVisionPose"
        private const val PERFORMANCE_LOG_INTERVAL = 30L
    }
}
