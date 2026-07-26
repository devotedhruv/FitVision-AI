# Permissions

The app targets SDK 36 and requests location only from Running Setup. It explains route collection, requests foreground location first, and requires precise (`ACCESS_FINE_LOCATION`) rather than silently accepting approximate location. Android 13+ notification permission is requested only when Start Run is pressed.

The service is started from a visible activity and declares the `location` foreground-service type. `ACCESS_BACKGROUND_LOCATION` is deliberately not requested: the selected visible-start location FGS flow does not require it. Permanent denial exposes Open Settings; disabled GPS and notification denial are distinct states.
