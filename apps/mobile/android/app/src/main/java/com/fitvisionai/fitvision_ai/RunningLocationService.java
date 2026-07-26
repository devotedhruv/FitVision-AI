package com.fitvisionai.fitvision_ai;

import android.Manifest;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Build;
import android.os.IBinder;
import android.os.Looper;
import android.os.SystemClock;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
import androidx.core.content.ContextCompat;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.Priority;
import io.flutter.plugin.common.EventChannel;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

public final class RunningLocationService extends Service {
  private static final String CHANNEL = "fitvision_running";
  private static final int NOTIFICATION_ID = 7407;
  private static volatile boolean running = false;
  private static volatile boolean paused = false;
  private static EventChannel.EventSink sink;
  private static RunningLocationService instance;

  private FusedLocationProviderClient locationClient;
  private LocationCallback locationCallback;
  private long startedElapsed;

  static void setSink(EventChannel.EventSink value) {
    sink = value;
  }

  static boolean isRunning() {
    return running;
  }

  static void setPaused(boolean value) {
    paused = value;
    if (instance != null) instance.notifyProgress(null, null);
  }

  static void updateProgress(Object duration, Object distance) {
    if (instance != null) instance.notifyProgress(duration, distance);
  }

  @Override
  public void onCreate() {
    super.onCreate();
    instance = this;
    locationClient = LocationServices.getFusedLocationProviderClient(this);
    locationCallback =
        new LocationCallback() {
          @Override
          public void onLocationResult(LocationResult result) {
            for (Location location : result.getLocations()) emitLocation(location);
          }
        };
    createChannel();
  }

  @Override
  public int onStartCommand(Intent intent, int flags, int startId) {
    if (running) return START_STICKY;

    running = true;
    paused = false;
    startedElapsed = SystemClock.elapsedRealtime();
    startForeground(NOTIFICATION_ID, notification("Acquiring precise location…"));

    if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
        != PackageManager.PERMISSION_GRANTED) {
      publishError("LOCATION_PERMISSION", "Precise location permission is required");
      stopSelf();
      return START_NOT_STICKY;
    }

    LocationRequest request =
        new LocationRequest.Builder(Priority.PRIORITY_HIGH_ACCURACY, 2000L)
            .setMinUpdateIntervalMillis(1000L)
            .setMinUpdateDistanceMeters(3f)
            .build();
    try {
      locationClient.requestLocationUpdates(request, locationCallback, Looper.getMainLooper());
    } catch (SecurityException exception) {
      publishError("LOCATION_PERMISSION", "Precise location permission is required");
      stopSelf();
      return START_NOT_STICKY;
    } catch (RuntimeException exception) {
      publishError("GPS_UNAVAILABLE", "Unable to start location tracking");
      stopSelf();
      return START_NOT_STICKY;
    }
    return START_STICKY;
  }

  private void emitLocation(Location location) {
    if (paused) return;
    EventChannel.EventSink current = sink;
    if (current == null) return;

    Map<String, Object> value = new HashMap<>();
    value.put("latitude", location.getLatitude());
    value.put("longitude", location.getLongitude());
    value.put("altitude", location.hasAltitude() ? location.getAltitude() : null);
    value.put("accuracy", (double) location.getAccuracy());
    value.put(
        "verticalAccuracy",
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && location.hasVerticalAccuracy()
            ? (double) location.getVerticalAccuracyMeters()
            : null);
    value.put("speed", location.hasSpeed() ? (double) location.getSpeed() : null);
    value.put(
        "speedAccuracy",
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && location.hasSpeedAccuracy()
            ? (double) location.getSpeedAccuracyMetersPerSecond()
            : null);
    value.put("bearing", location.hasBearing() ? (double) location.getBearing() : null);
    value.put("timestamp", location.getTime());
    value.put("elapsedRealtimeMs", location.getElapsedRealtimeNanos() / 1_000_000L);
    current.success(value);
  }

  private void publishError(String code, String message) {
    EventChannel.EventSink current = sink;
    if (current != null) current.error(code, message, null);
  }

  private void createChannel() {
    NotificationManager manager = getSystemService(NotificationManager.class);
    manager.createNotificationChannel(
        new NotificationChannel(
            CHANNEL, "Active run tracking", NotificationManager.IMPORTANCE_LOW));
  }

  private Notification notification(String text) {
    Intent open = new Intent(this, MainActivity.class);
    PendingIntent pendingIntent =
        PendingIntent.getActivity(
            this,
            0,
            open,
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
    return new NotificationCompat.Builder(this, CHANNEL)
        .setSmallIcon(android.R.drawable.ic_menu_mylocation)
        .setContentTitle(paused ? "Run paused" : "FitVision run in progress")
        .setContentText(text)
        .setOngoing(true)
        .setOnlyAlertOnce(true)
        .setContentIntent(pendingIntent)
        .setCategory(NotificationCompat.CATEGORY_SERVICE)
        .build();
  }

  private void notifyProgress(Object duration, Object distance) {
    String elapsed =
        duration == null
            ? format(SystemClock.elapsedRealtime() - startedElapsed)
            : duration.toString();
    String kilometers = distance == null ? "0.00" : distance.toString();
    getSystemService(NotificationManager.class)
        .notify(NOTIFICATION_ID, notification(elapsed + " • " + kilometers + " km"));
  }

  private String format(long milliseconds) {
    long seconds = Math.max(0, milliseconds / 1000);
    return String.format(Locale.US, "%02d:%02d", seconds / 60, seconds % 60);
  }

  @Override
  public void onDestroy() {
    if (locationClient != null && locationCallback != null) {
      locationClient.removeLocationUpdates(locationCallback);
    }
    stopForeground(STOP_FOREGROUND_REMOVE);
    running = false;
    paused = false;
    instance = null;
    super.onDestroy();
  }

  @Nullable
  @Override
  public IBinder onBind(Intent intent) {
    return null;
  }
}
