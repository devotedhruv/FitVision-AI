# State machines

All transitions require three consecutive qualifying frames and use separate
enter/exit thresholds (hysteresis). Holding a state cannot count a rep.

- Squat: `standing → descending → bottom → ascending → standing`.
- Curl: `extended → flexing → contracted → extending → extended`.
- Push-up: `top → descending → bottom → ascending → top`.

A cycle must take 500 ms–10 s. Returning to the initial state without reaching
the terminal movement state is incomplete. Tracking loss beyond the smoothing
gap or finishing with an active cycle is also incomplete. Pausing freezes
transitions; resuming clears smoothing and pending stability frames.
