package com.fitvisionai.pose_landmarker

internal class CameraResourceLifecycle(
    private val pauseResources: () -> Unit,
    private val resumeResources: () -> Unit,
    private val disposeResources: () -> Unit,
) {
    enum class State { ACTIVE, PAUSED, DISPOSED }

    var state: State = State.ACTIVE
        private set

    val isActive: Boolean get() = state == State.ACTIVE
    val isPaused: Boolean get() = state == State.PAUSED
    val isDisposed: Boolean get() = state == State.DISPOSED

    fun pause(): Boolean {
        if (!isActive) return false
        pauseResources()
        state = State.PAUSED
        return true
    }

    fun resume(): Boolean {
        if (!isPaused) return false
        state = State.ACTIVE
        resumeResources()
        return true
    }

    fun dispose(): Boolean {
        if (isDisposed) return false
        disposeResources()
        state = State.DISPOSED
        return true
    }
}

internal class PluginAttachmentGuard {
    private var attached = false

    fun attach(): Boolean {
        if (attached) return false
        attached = true
        return true
    }

    fun detach() {
        attached = false
    }
}
