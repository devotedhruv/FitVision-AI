package com.fitvisionai.pose_landmarker

import android.graphics.Bitmap
import android.graphics.Matrix
import android.os.SystemClock
import androidx.camera.core.ImageProxy
import com.google.mediapipe.framework.image.BitmapImageBuilder

internal class CameraFrameProcessor(
    private val frontCamera: () -> Boolean,
    private val landmarker: PoseLandmarkerHelper,
    private val onError: (String, String) -> Unit,
) : androidx.camera.core.ImageAnalysis.Analyzer {
    private val timestamps = MonotonicTimestampSource(SystemClock::uptimeMillis)

    override fun analyze(image: ImageProxy) {
        CloseGuard.use(close = image::close) {
            try {
                val rotation = image.imageInfo.rotationDegrees
                val source = image.toBitmap()
                val rotated = rotate(source, rotation)
                val metadata =
                    FrameMetadata(
                        timestampMs = timestamps.next(),
                        startedAtMs = SystemClock.uptimeMillis(),
                        imageWidth = rotated.width,
                        imageHeight = rotated.height,
                        rotation = 0,
                        frontCamera = frontCamera(),
                    )
                landmarker.detect(BitmapImageBuilder(rotated).build(), metadata)
            } catch (error: RuntimeException) {
                onError("camera_error", error.message ?: "Camera frame conversion failed.")
            }
        }
    }

    private fun rotate(source: Bitmap, degrees: Int): Bitmap {
        if (degrees == 0) return source
        val matrix = Matrix().apply { postRotate(degrees.toFloat()) }
        return Bitmap.createBitmap(source, 0, 0, source.width, source.height, matrix, true)
    }
}
