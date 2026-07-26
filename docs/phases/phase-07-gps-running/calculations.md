# Calculations

Distance uses double-precision Haversine with a 6,371,000 m Earth radius. Instant speed is accepted segment distance divided by segment time. EMA alpha 0.35 smooths speed. Average speed is accepted distance divided by active duration; pace is active seconds divided by kilometres. Pace remains `--:--` below 20 m or when time/distance is zero.
