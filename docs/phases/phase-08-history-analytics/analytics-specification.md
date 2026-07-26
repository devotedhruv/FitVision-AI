# Analytics specification

| Metric | Source | Formula | Null/sample rule | Direction |
|---|---|---|---|---|
| Completed reps | completed workout aggregate | sum `completed_rep_count` | zero only when sessions exist | neutral |
| Valid-form ratio | completed workouts | valid reps / completed reps | null at zero completed reps | higher better |
| Form score | non-null same-exercise scores | arithmetic mean | never substitute zero; 2+ each period for trend | higher better |
| Active days | completed workouts+runs | unique local calendar dates | zero for empty period | contextual |
| Run distance | completed runs | sum metres | zero only when runs exist | neutral |
| Weighted pace | valid completed runs | total active seconds / total kilometres | null at zero distance/time; 2+ each period for trend | lower better |

Timestamps remain UTC in storage. Calendar inclusion is start-inclusive/end-exclusive after local boundaries convert to UTC. Display rounding: km one decimal in summary, pace nearest second, ratios whole percent where shown.
