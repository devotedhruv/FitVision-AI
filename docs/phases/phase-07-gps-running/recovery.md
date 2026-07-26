# Recovery

On application reconstruction, an active local run is conservatively changed to paused; it never invents distance for an unknown interval or silently resumes collection. A paused run remains paused and can resume with a fresh GPS anchor. The native service reports whether it is already active so duplicate starts are avoided. Runs are never silently deleted.
