package com.fitvisionai.pose_landmarker

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class ResourceLifecycleTest {
    @Test
    fun `pause resume and dispose release resources exactly once`() {
        var pauses = 0
        var resumes = 0
        var disposals = 0
        val lifecycle =
            CameraResourceLifecycle(
                pauseResources = { pauses += 1 },
                resumeResources = { resumes += 1 },
                disposeResources = { disposals += 1 },
            )

        assertTrue(lifecycle.pause())
        assertFalse(lifecycle.pause())
        assertEquals(1, pauses)
        assertTrue(lifecycle.resume())
        assertFalse(lifecycle.resume())
        assertEquals(1, resumes)
        assertTrue(lifecycle.dispose())
        assertFalse(lifecycle.dispose())
        assertEquals(1, disposals)
        assertTrue(lifecycle.isDisposed)
    }

    @Test
    fun `disposed lifecycle cannot resume`() {
        val lifecycle = CameraResourceLifecycle({}, {}, {})
        lifecycle.dispose()

        assertFalse(lifecycle.resume())
        assertFalse(lifecycle.pause())
    }
}
