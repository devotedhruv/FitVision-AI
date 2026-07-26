package com.fitvisionai.pose_landmarker

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class PoseFrameClassifierTest {
    @Test
    fun `all 33 visible landmarks map with stable indices and detected status`() {
        val landmarks = landmarks(visibility = 0.9f)
        val classification = PoseFrameClassifier.classify(landmarks, 0.5f)
        val payload = landmarks.map(PoseLandmarkValue::toPayload)

        assertEquals(PoseFrameClassifier.EXPECTED_LANDMARK_COUNT, payload.size)
        assertEquals((0..32).toList(), payload.map { it["index"] })
        assertEquals("poseDetected", classification.status)
    }

    @Test
    fun `empty landmarks map to no pose`() {
        val classification = PoseFrameClassifier.classify(emptyList(), 0.5f)

        assertEquals("noPose", classification.status)
        assertTrue(classification.message.contains("center"))
    }

    @Test
    fun `missing required lower body landmarks maps to partial pose`() {
        val landmarks = landmarks(visibility = 0.9f).toMutableList()
        for (index in listOf(25, 26, 27, 28)) {
            landmarks[index] = landmarks[index].copy(visibility = 0.1f, presence = 0.1f)
        }

        val classification = PoseFrameClassifier.classify(landmarks, 0.5f)

        assertEquals("partialPose", classification.status)
        assertTrue(classification.message.contains("Move back"))
    }

    @Test
    fun `low confidence required landmarks map to poor visibility`() {
        val classification = PoseFrameClassifier.classify(landmarks(visibility = 0.1f), 0.5f)

        assertEquals("poorVisibility", classification.status)
        assertFalse(classification.message.isBlank())
    }

    private fun landmarks(visibility: Float): List<PoseLandmarkValue> =
        List(33) { index ->
            PoseLandmarkValue(
                index = index,
                x = 0.5f,
                y = 0.5f,
                z = 0f,
                visibility = visibility,
                presence = visibility,
            )
        }
}
