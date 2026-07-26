# Sync strategy

Sync runs at app launch, authenticated-state recovery, connectivity return,
foreground resume, workout completion and manual retry. Connectivity is only a
signal; the API response determines success.

One in-process single-flight guard prevents concurrent loops. Stuck processing
jobs return to pending at initialization. Jobs use bounded exponential backoff
starting near 5 seconds, growing by 3× with jitter and capped at 15 minutes;
the default maximum is eight attempts. Network, timeout and server failures are
retryable. Authentication, authorization and validation failures require user
or payload correction and do not tight-loop.

The existing API accepts a completed workout plus ordered reps atomically, so
the mobile queue uploads one completed parent payload. A draft job is persisted
at start but is not eligible until local completion. Android background
execution outside the running/foreground app is not scheduled in this phase;
the OS may delay the next opportunity until launch or foreground return.
