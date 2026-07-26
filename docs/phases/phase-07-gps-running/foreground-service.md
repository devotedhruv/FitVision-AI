# Foreground service

`RunningLocationService` starts only after local session creation from Start Run. It creates a low-importance notification channel, calls `startForeground` immediately, samples GPS every two seconds with three-metre displacement, and emits accuracy/timestamp/speed metadata. The notification is ongoing and receives controlled duration/distance updates. Pause retains the service but excludes samples; finish removes updates and notification.

The service has no camera, MediaPipe, map-rendering or network responsibilities.
