# Local storage

Drift schema version is **2**. The non-destructive version 1→2 migration adds `running_sessions`, `running_points` and indexes without altering workout data. Points have cascade ownership and unique session/sequence ordering. Each accepted/rejected point insertion and aggregate update is transactional. Timer segments persist on start, pause, resume and finish; ticks are not persisted.
