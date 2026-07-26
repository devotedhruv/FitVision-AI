# Exercise evaluation report

| Measurement | Result | Target | Sample/environment | Verdict |
|---|---:|---:|---|---|
| Synthetic exact rep agreement | 100% | 95% provisional | 2 synthetic regression sessions | pipeline check only |
| Synthetic mean absolute error | 0.0 | ≤0.2 | 2 synthetic regression sessions | pipeline check only |
| Human complete-rep agreement | NOT TESTED | ≥95% | no consented/holdout dataset | BLOCKED |
| Duplicate-rep rate | NOT TESTED | <1% | no holdout dataset | BLOCKED |
| Incomplete precision/recall | NOT TESTED | ≥90% | no holdout dataset | BLOCKED |
| Form-rule precision/recall | NOT TESTED | ≥85–90% | no labeled form dataset | BLOCKED |
| Device p95/feedback latency/FPS | NOT TESTED | real-time / <500 ms / ≥15 FPS | no profile-device run | BLOCKED |

Synthetic frame timings exist solely to test percentile calculation and must not be quoted as engine performance. Rule version is 1.0.0; no thresholds changed.
