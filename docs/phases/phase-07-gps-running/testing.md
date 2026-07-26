# Testing and device checklist

Automated tests use synthetic routes and in-memory Drift. Physical-device checks must cover fresh/approximate/precise/denied/permanently-denied permission, GPS disabled/weak, outdoor start, screen off, background/foreground, pause while moving, resume elsewhere, finish, notification visibility, temporary network loss, process recreation, force-stop, battery saver, long-run battery use, route continuity and duplicate upload retry.

Record Android version, manufacturer, duration, battery delta and route comparison for every device run.
