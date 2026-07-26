package com.fitvisionai.pose_landmarker

import com.google.mediapipe.tasks.components.containers.NormalizedLandmark
import com.google.mediapipe.tasks.components.containers.Landmark
import com.google.mediapipe.tasks.vision.poselandmarker.PoseLandmarkerResult

internal object PoseResultMapper {
    fun map(
        result: PoseLandmarkerResult,
        metadata: FrameMetadata,
        droppedFrames: Long,
        processedFps: Double,
        visibilityThreshold: Float,
    ): Map<String, Any?> {
        val pose = result.landmarks().firstOrNull().orEmpty().mapIndexed(::normalizedLandmark)
        val worldPose = result.worldLandmarks().firstOrNull().orEmpty().mapIndexed(::worldLandmark)
        val classification = PoseFrameClassifier.classify(pose, visibilityThreshold)
        return mapOf(
            "timestamp" to metadata.timestampMs,
            "imageWidth" to metadata.imageWidth,
            "imageHeight" to metadata.imageHeight,
            "rotation" to metadata.rotation,
            "lensDirection" to if (metadata.frontCamera) "front" else "back",
            "inferenceLatencyMs" to metadata.inferenceLatencyMs(),
            "poseDetected" to (pose.size == PoseFrameClassifier.EXPECTED_LANDMARK_COUNT),
            "status" to classification.status,
            "landmarks" to pose.map(PoseLandmarkValue::toPayload),
            "worldLandmarks" to worldPose.map(PoseLandmarkValue::toPayload),
            "processedFps" to processedFps,
            "droppedFrames" to droppedFrames,
            "message" to classification.message,
        )
    }

    private fun normalizedLandmark(index: Int, landmark: NormalizedLandmark): PoseLandmarkValue =
        PoseLandmarkValue(
            index = index,
            x = landmark.x(),
            y = landmark.y(),
            z = landmark.z(),
            visibility = landmark.visibility().orElse(0f),
            presence = landmark.presence().orElse(0f),
        )

    private fun worldLandmark(index: Int, landmark: Landmark): PoseLandmarkValue =
        PoseLandmarkValue(
            index = index,
            x = landmark.x(),
            y = landmark.y(),
            z = landmark.z(),
            visibility = landmark.visibility().orElse(0f),
            presence = landmark.presence().orElse(0f),
        )
}

internal data class FrameMetadata(
    val timestampMs: Long,
    val startedAtMs: Long,
    val imageWidth: Int,
    val imageHeight: Int,
    val rotation: Int,
    val frontCamera: Boolean,
) {
    fun inferenceLatencyMs(nowMs: Long = android.os.SystemClock.uptimeMillis()): Double =
        (nowMs - startedAtMs).coerceAtLeast(0).toDouble()
}
