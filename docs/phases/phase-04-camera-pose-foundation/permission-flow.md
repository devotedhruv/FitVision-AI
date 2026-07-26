# Permission Flow

The main manifest declares:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-feature android:name="android.hardware.camera.any" android:required="false"/>
```

The application does not request camera access at launch. It asks only after
the user opens an exercise camera guide and presses `Enable camera`.

- Granted: initialize model and camera.
- Denied: show a recoverable explanation; the rest of the app remains usable.
- Permanently denied/restricted: show `Open Settings`.
- Missing camera: show a typed camera error.

No microphone, storage or location permission was added. Location remains a
later running/GPS phase.

Privacy copy states that pose processing occurs on-device, raw video is not
uploaded, raw video is not saved by default, and only future structured workout
summaries may synchronize.
