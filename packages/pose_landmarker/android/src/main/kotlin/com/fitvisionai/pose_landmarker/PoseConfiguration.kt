package com.fitvisionai.pose_landmarker

data class PoseLandmarkerConfiguration(
    val detectionConfidence: Float = 0.5f,
    val presenceConfidence: Float = 0.5f,
    val trackingConfidence: Float = 0.5f,
    val numberOfPoses: Int = 1,
    val segmentationMasksEnabled: Boolean = false,
) {
    init {
        require(detectionConfidence in 0f..1f)
        require(presenceConfidence in 0f..1f)
        require(trackingConfidence in 0f..1f)
        require(numberOfPoses == 1) { "Phase 4 supports exactly one pose." }
    }

    companion object {
        fun fromPlatformMap(values: Map<*, *>): PoseLandmarkerConfiguration =
            PoseLandmarkerConfiguration(
                detectionConfidence =
                    (values["detectionConfidence"] as? Number)?.toFloat() ?: 0.5f,
                presenceConfidence =
                    (values["presenceConfidence"] as? Number)?.toFloat() ?: 0.5f,
                trackingConfidence =
                    (values["trackingConfidence"] as? Number)?.toFloat() ?: 0.5f,
            )
    }
}
