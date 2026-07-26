package com.fitvisionai.pose_landmarker

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertTrue

class PoseCoreSafetyTest {
    @Test
    fun `missing model produces typed initialization failure`() {
        val error =
            assertFailsWith<PoseModelException> {
                ModelAssetValidator.requireAvailable("pose_landmarker_lite.task") { false }
            }

        assertEquals("model_missing", error.code)
        assertTrue(error.message.contains("pose_landmarker_lite.task"))
    }

    @Test
    fun `monotonic timestamps increase when the clock repeats or moves backwards`() {
        val clockValues = ArrayDeque(listOf(100L, 100L, 95L, 110L))
        val timestamps = MonotonicTimestampSource { clockValues.removeFirst() }

        assertEquals(listOf(100L, 101L, 102L, 110L), List(4) { timestamps.next() })
    }

    @Test
    fun `close guard closes frame after successful processing`() {
        var closed = false

        val result = CloseGuard.use(close = { closed = true }) { "processed" }

        assertEquals("processed", result)
        assertTrue(closed)
    }

    @Test
    fun `close guard closes frame after processing error`() {
        var closed = false

        assertFailsWith<IllegalStateException> {
            CloseGuard.use(close = { closed = true }) {
                throw IllegalStateException("conversion failed")
            }
        }
        assertTrue(closed)
    }
}
