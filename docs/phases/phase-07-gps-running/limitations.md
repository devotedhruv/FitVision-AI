# Limitations

- Android does not guarantee work after user force-stop, reboot, permission revocation or aggressive manufacturer battery restrictions.
- GPS can be unavailable indoors and urban multipath can distort routes.
- The route canvas is an offline schematic polyline, not a tile map; recording is intentionally independent of tile/network availability.
- Notification actions are deferred until their persistence semantics can be validated on physical devices; pause/resume/finish remain in-app.
- Process death can stop the Flutter engine and native service together; persisted points remain recoverable, but no missing distance is invented.
- Background/screen-off behavior requires physical-device validation and is not proven by unit tests alone.
