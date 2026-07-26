# Calibration dataset protocol

Use synthetic landmark sequences first, then short consented-adult sessions covering every exercise, correct/partial/hold, speed, tracking loss, lighting, distance, side, mirroring and orientation condition. Stop on discomfort; make no medical claims. Assign anonymous IDs, remove media metadata, keep raw video under `ai/evaluation/private/` outside git, never upload it to production, and delete it on consent withdrawal.

Maintain three immutable manifest splits: calibration for tuning, locked holdout for final evaluation, and regression for every preserved failure. Labels may not be changed to improve metrics.
