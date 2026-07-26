# Architecture

Separate workout/run tables remain authoritative. A paginated SQL `UNION ALL` creates lightweight history cards; details load reps or route points only when opened. Analytics queries completed summary rows for the selected user and period, then pure calculators build progress and rule results. UI always reads local data first.
