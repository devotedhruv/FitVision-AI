package com.fitvisionai.pose_landmarker

import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.atomic.AtomicLong

internal class FrameBusyGuard {
    private val busy = AtomicBoolean(false)
    private val dropped = AtomicLong(0)

    fun tryAcquire(): Boolean {
        val acquired = busy.compareAndSet(false, true)
        if (!acquired) dropped.incrementAndGet()
        return acquired
    }

    fun release() {
        busy.set(false)
    }

    fun droppedFrames(): Long = dropped.get()
}
