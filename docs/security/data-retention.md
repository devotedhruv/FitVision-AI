# Data retention

Camera frames and video are transient and are neither stored nor uploaded. Pose frames are not persisted. Workout results, rep results, accepted running points and derived analytics persist locally and remotely until explicit deletion. Rejected GPS points may remain locally for diagnostics under current schema but are not required for upload. Individual remote workout/run deletes cascade to children; local workout soft deletion supports queued synchronization while running deletion behavior must preserve pending intent.

No automatic retention expiry is currently implemented. Private calibration media is never committed and follows participant consent/deletion terms.
