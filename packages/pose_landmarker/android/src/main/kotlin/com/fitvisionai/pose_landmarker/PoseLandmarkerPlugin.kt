package com.fitvisionai.pose_landmarker

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PoseLandmarkerPlugin :
    FlutterPlugin,
    ActivityAware,
    MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler {
    private lateinit var commands: MethodChannel
    private lateinit var events: EventChannel
    private var activity: Activity? = null
    private var activeView: PoseCameraView? = null
    private var eventSink: EventChannel.EventSink? = null
    private val attachmentGuard = PluginAttachmentGuard()

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        if (!attachmentGuard.attach()) return
        commands = MethodChannel(binding.binaryMessenger, COMMAND_CHANNEL)
        events = EventChannel(binding.binaryMessenger, EVENT_CHANNEL)
        commands.setMethodCallHandler(this)
        events.setStreamHandler(this)
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE,
            PoseCameraViewFactory(
                activityProvider = { activity },
                eventEmitter = { payload -> eventSink?.success(payload) },
                errorEmitter = { code, message -> eventSink?.error(code, message, null) },
                onViewCreated = { view ->
                    activeView?.dispose()
                    activeView = view
                },
            ),
        )
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val view = activeView
        if (view == null) {
            result.error("camera_unavailable", "The pose camera view is not active.", null)
            return
        }
        when (call.method) {
            "pause" -> view.pause()
            "resume" -> view.resume()
            "switchCamera" -> view.switchCamera()
            "dispose" -> {
                view.dispose()
                activeView = null
            }
            else -> {
                result.notImplemented()
                return
            }
        }
        result.success(null)
    }

    override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
        eventSink = sink
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activeView?.pause()
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        activeView?.resume()
    }

    override fun onDetachedFromActivity() {
        activeView?.dispose()
        activeView = null
        activity = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        activeView?.dispose()
        activeView = null
        commands.setMethodCallHandler(null)
        events.setStreamHandler(null)
        attachmentGuard.detach()
    }

    companion object {
        const val VIEW_TYPE = "fitvision/pose_camera_view"
        const val COMMAND_CHANNEL = "fitvision/pose_landmarker/commands"
        const val EVENT_CHANNEL = "fitvision/pose_landmarker/events"
    }
}
