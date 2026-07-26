package com.fitvisionai.fitvision_ai;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.provider.Settings;
import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public final class MainActivity extends FlutterActivity {
  private static final String METHODS="com.fitvisionai/running/methods";
  private static final String EVENTS="com.fitvisionai/running/locations";
  @Override public void configureFlutterEngine(@NonNull FlutterEngine engine){
    super.configureFlutterEngine(engine);
    new EventChannel(engine.getDartExecutor().getBinaryMessenger(),EVENTS).setStreamHandler(new EventChannel.StreamHandler(){
      public void onListen(Object args,EventChannel.EventSink sink){RunningLocationService.setSink(sink);}
      public void onCancel(Object args){RunningLocationService.setSink(null);}
    });
    new MethodChannel(engine.getDartExecutor().getBinaryMessenger(),METHODS).setMethodCallHandler((call,result)->{
      switch(call.method){
        case "isPrecise": result.success(ContextCompat.checkSelfPermission(this,Manifest.permission.ACCESS_FINE_LOCATION)==PackageManager.PERMISSION_GRANTED); break;
        case "isLocationEnabled": LocationManager lm=(LocationManager)getSystemService(LOCATION_SERVICE); result.success(lm.isProviderEnabled(LocationManager.GPS_PROVIDER)); break;
        case "openLocationSettings": startActivity(new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)); result.success(null); break;
        case "isTracking": result.success(RunningLocationService.isRunning()); break;
        case "start": try { Intent i=new Intent(this,RunningLocationService.class); i.putExtra("runId",call.argument("runId").toString()); ContextCompat.startForegroundService(this,i); result.success(null); } catch(Exception e){result.error("FOREGROUND_SERVICE", "Unable to start run tracking",null);} break;
        case "pause": RunningLocationService.setPaused(true); result.success(null); break;
        case "resume": RunningLocationService.setPaused(false); result.success(null); break;
        case "update": RunningLocationService.updateProgress(call.argument("duration"),call.argument("distance")); result.success(null); break;
        case "stop": stopService(new Intent(this,RunningLocationService.class)); result.success(null); break;
        default: result.notImplemented();
      }
    });
  }
}
