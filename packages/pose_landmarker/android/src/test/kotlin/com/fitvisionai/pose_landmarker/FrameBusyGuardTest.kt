package com.fitvisionai.pose_landmarker

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class FrameBusyGuardTest {
    @Test
    fun `busy frames are dropped until processing releases`() {
        val guard = FrameBusyGuard()

        assertTrue(guard.tryAcquire())
        assertFalse(guard.tryAcquire())
        assertEquals(1, guard.droppedFrames())

        guard.release()
        assertTrue(guard.tryAcquire())
    }
}

