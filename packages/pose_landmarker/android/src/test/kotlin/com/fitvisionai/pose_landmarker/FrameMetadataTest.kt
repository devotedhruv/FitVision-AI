package com.fitvisionai.pose_landmarker

import kotlin.test.Test
import kotlin.test.assertEquals

class FrameMetadataTest {
    @Test
    fun `latency never reports a negative duration`() {
        val metadata =
            FrameMetadata(
                timestampMs = 10,
                startedAtMs = 100,
                imageWidth = 480,
                imageHeight = 640,
                rotation = 0,
                frontCamera = true,
            )

        assertEquals(0.0, metadata.inferenceLatencyMs(nowMs = 90))
        assertEquals(50.0, metadata.inferenceLatencyMs(nowMs = 150))
    }
}
