# Recovery

On recovery, a locally active workout is conservatively closed at the current
UTC time and restored as paused. It never silently resumes pose processing.
Opening the matching exercise reports the saved paused workout; completing the
camera/countdown flow resumes it and preserves accumulated duration and rep
sequence. A paused session remains paused.

Queue jobs left in processing are reset to pending on SyncManager startup.
Unsynced records are preserved across logout and app restart. Explicit discard
and soft deletion are not currently exposed, so interrupted data is never
silently deleted.
