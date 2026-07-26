package com.fitvisionai.pose_landmarker

import android.content.Context
import com.google.mediapipe.tasks.core.BaseOptions
import com.google.mediapipe.tasks.vision.core.RunningMode
import com.google.mediapipe.tasks.vision.poselandmarker.PoseLandmarker
import com.google.mediapipe.tasks.vision.poselandmarker.PoseLandmarkerResult

internal class PoseLandmarkerHelper(
    context: Context,
    private val configuration: PoseLandmarkerConfiguration,
    private val onResult: (PoseLandmarkerResult, FrameMetadata) -> Unit,
    private val onError: (String, String) -> Unit,
) : AutoCloseable {
    private val guard = FrameBusyGuard()
    private val pendingMetadata = java.util.concurrent.ConcurrentHashMap<Long, FrameMetadata>()
    private var processedFrames = 0L
    private val startedAtMs = android.os.SystemClock.uptimeMillis()
    private val landmarker: PoseLandmarker

    init {
        ModelAssetValidator.requireAvailable(MODEL_ASSET) {
            try {
                context.assets.open(MODEL_ASSET).use { }
                true
            } catch (_: java.io.IOException) {
                false
            }
        }
        val options =
            PoseLandmarker.PoseLandmarkerOptions.builder()
                .setBaseOptions(
                    BaseOptions.builder()
                        .setModelAssetPath(MODEL_ASSET)
                        .build(),
                )
                .setRunningMode(RunningMode.LIVE_STREAM)
                .setNumPoses(configuration.numberOfPoses)
                .setOutputSegmentationMasks(configuration.segmentationMasksEnabled)
                .setMinPoseDetectionConfidence(configuration.detectionConfidence)
                .setMinPosePresenceConfidence(configuration.presenceConfidence)
                .setMinTrackingConfidence(configuration.trackingConfidence)
                .setResultListener { result, _ ->
                    val metadata = pendingMetadata.remove(result.timestampMs())
                    guard.release()
                    if (metadata != null) {
                        processedFrames += 1
                        onResult(result, metadata)
                    }
                }
                .setErrorListener { error ->
                    guard.release()
                    onError("model_error", error.message ?: "Pose Landmarker failed.")
                }
                .build()
        landmarker = PoseLandmarker.createFromOptions(context, options)
    }

    fun detect(image: com.google.mediapipe.framework.image.MPImage, metadata: FrameMetadata) {
        if (!guard.tryAcquire()) return
        pendingMetadata[metadata.timestampMs] = metadata
        try {
            landmarker.detectAsync(image, metadata.timestampMs)
        } catch (error: RuntimeException) {
            pendingMetadata.remove(metadata.timestampMs)
            guard.release()
            onError("model_error", error.message ?: "Pose inference failed.")
        }
    }

    fun mappedResult(result: PoseLandmarkerResult, metadata: FrameMetadata): Map<String, Any?> =
        PoseResultMapper.map(
            result = result,
            metadata = metadata,
            droppedFrames = guard.droppedFrames(),
            processedFps = processedFps(),
            visibilityThreshold = configuration.presenceConfidence,
        )

    private fun processedFps(): Double {
        val elapsedSeconds =
            (android.os.SystemClock.uptimeMillis() - startedAtMs).coerceAtLeast(1) / 1000.0
        return processedFrames / elapsedSeconds
    }

    override fun close() {
        pendingMetadata.clear()
        landmarker.close()
    }

    companion object {
        const val MODEL_ASSET = "pose_landmarker_lite.task"
    }
}
