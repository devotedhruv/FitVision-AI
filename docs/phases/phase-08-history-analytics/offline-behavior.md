# Offline behavior

History, details, periods and insights calculate from SQLite and therefore include unsynced sessions. Refresh failure never clears local results. Server aggregates are not blindly added to local values; local analytics remain authoritative until a future remote merge can prove client-UUID equivalence. Cache complexity is avoided—Drift changes and explicit refresh invalidate view-model results.
