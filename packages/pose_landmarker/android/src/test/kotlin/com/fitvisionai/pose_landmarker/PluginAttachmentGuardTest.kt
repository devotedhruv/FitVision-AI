package com.fitvisionai.pose_landmarker

import kotlin.test.Test
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class PluginAttachmentGuardTest {
    @Test
    fun `duplicate registration is rejected until detach`() {
        val guard = PluginAttachmentGuard()

        assertTrue(guard.attach())
        assertFalse(guard.attach())
        guard.detach()
        assertTrue(guard.attach())
    }
}
