package com.fitvisionai.pose_landmarker

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class PoseCameraViewFactory(
    private val activityProvider: () -> Activity?,
    private val eventEmitter: (Map<String, Any?>) -> Unit,
    private val errorEmitter: (String, String) -> Unit,
    private val onViewCreated: (PoseCameraView) -> Unit,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val config = (args as? Map<*, *>).orEmpty()
        val poseConfiguration = PoseLandmarkerConfiguration.fromPlatformMap(config)
        val view =
            PoseCameraView(
                context = context,
                activity = activityProvider(),
                initialFrontCamera = config["frontCamera"] as? Boolean ?: true,
                configuration = poseConfiguration,
                eventEmitter = eventEmitter,
                errorEmitter = errorEmitter,
            )
        onViewCreated(view)
        return view
    }
}
