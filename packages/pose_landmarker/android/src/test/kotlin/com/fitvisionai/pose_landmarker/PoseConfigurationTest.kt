package com.fitvisionai.pose_landmarker

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertFalse

class PoseConfigurationTest {
    @Test
    fun `platform configuration maps centralized thresholds and Phase 4 defaults`() {
        val configuration =
            PoseLandmarkerConfiguration.fromPlatformMap(
                mapOf(
                    "detectionConfidence" to 0.6,
                    "presenceConfidence" to 0.7,
                    "trackingConfidence" to 0.8,
                ),
            )

        assertEquals(0.6f, configuration.detectionConfidence)
        assertEquals(0.7f, configuration.presenceConfidence)
        assertEquals(0.8f, configuration.trackingConfidence)
        assertEquals(1, configuration.numberOfPoses)
        assertFalse(configuration.segmentationMasksEnabled)
    }

    @Test
    fun `invalid confidence is rejected`() {
        assertFailsWith<IllegalArgumentException> {
            PoseLandmarkerConfiguration(detectionConfidence = 1.1f)
        }
    }
}
