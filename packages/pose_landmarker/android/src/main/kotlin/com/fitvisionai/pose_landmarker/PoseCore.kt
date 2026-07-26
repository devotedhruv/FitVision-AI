package com.fitvisionai.pose_landmarker

import java.util.concurrent.atomic.AtomicLong

internal data class PoseLandmarkValue(
    val index: Int,
    val x: Float,
    val y: Float,
    val z: Float,
    val visibility: Float,
    val presence: Float,
) {
    fun toPayload(): Map<String, Any> =
        mapOf(
            "index" to index,
            "x" to x,
            "y" to y,
            "z" to z,
            "visibility" to visibility,
            "presence" to presence,
        )
}

internal data class PoseClassification(val status: String, val message: String)

internal object PoseFrameClassifier {
    val requiredFullBodyIndices = intArrayOf(11, 12, 23, 24, 25, 26, 27, 28)

    fun classify(
        landmarks: List<PoseLandmarkValue>,
        visibilityThreshold: Float,
    ): PoseClassification {
        val visibleRequired =
            requiredFullBodyIndices.count { index ->
                landmarks.getOrNull(index)?.let {
                    it.visibility >= visibilityThreshold && it.presence >= visibilityThreshold
                } == true
            }
        val status =
            when {
                landmarks.isEmpty() -> "noPose"
                landmarks.size != EXPECTED_LANDMARK_COUNT -> "partialPose"
                visibleRequired == requiredFullBodyIndices.size -> "poseDetected"
                visibleRequired >= requiredFullBodyIndices.size / 2 -> "partialPose"
                else -> "poorVisibility"
            }
        val message =
            when (status) {
                "noPose" -> "Move into the center of the frame."
                "partialPose" -> "Move back so your full body is visible."
                "poorVisibility" -> "Improve the lighting and keep your full body visible."
                else -> "Body landmarks detected."
            }
        return PoseClassification(status, message)
    }

    const val EXPECTED_LANDMARK_COUNT = 33
}

internal class PoseModelException(
    val code: String,
    override val message: String,
) : RuntimeException(message)

internal object ModelAssetValidator {
    fun requireAvailable(assetName: String, exists: () -> Boolean) {
        if (!exists()) {
            throw PoseModelException(
                code = "model_missing",
                message = "Required pose model asset is missing: $assetName",
            )
        }
    }
}

internal class MonotonicTimestampSource(private val clockMs: () -> Long) {
    private val previous = AtomicLong(0)

    fun next(): Long {
        while (true) {
            val last = previous.get()
            val candidate = maxOf(clockMs(), last + 1)
            if (previous.compareAndSet(last, candidate)) return candidate
        }
    }
}

internal object CloseGuard {
    inline fun <T> use(close: () -> Unit, block: () -> T): T =
        try {
            block()
        } finally {
            close()
        }
}
