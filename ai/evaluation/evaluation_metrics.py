"""Deterministic Phase 9 evaluation metrics; no participant identifiers."""

from __future__ import annotations

from dataclasses import dataclass
from math import ceil
from statistics import median
from typing import Iterable


def percentile(values: Iterable[float], quantile: float) -> float | None:
    ordered = sorted(values)
    if not ordered:
        return None
    index = max(0, min(len(ordered) - 1, ceil(quantile * len(ordered)) - 1))
    return ordered[index]


def safe_ratio(numerator: float, denominator: float) -> float | None:
    return numerator / denominator if denominator else None


@dataclass(frozen=True)
class CountMetrics:
    sample_count: int
    exact_agreement_rate: float | None
    mean_absolute_error: float | None
    over_count_rate: float | None
    under_count_rate: float | None


def count_metrics(expected: list[int], actual: list[int]) -> CountMetrics:
    if len(expected) != len(actual):
        raise ValueError("Expected and actual counts must have equal length")
    errors = [observed - target for target, observed in zip(expected, actual, strict=True)]
    count = len(errors)
    return CountMetrics(
        count,
        safe_ratio(sum(error == 0 for error in errors), count),
        safe_ratio(sum(abs(error) for error in errors), count),
        safe_ratio(sum(error > 0 for error in errors), count),
        safe_ratio(sum(error < 0 for error in errors), count),
    )


def binary_metrics(tp: int, fp: int, fn: int) -> dict[str, float | None]:
    precision = safe_ratio(tp, tp + fp)
    recall = safe_ratio(tp, tp + fn)
    f1 = None if precision is None or recall is None or precision + recall == 0 else 2 * precision * recall / (precision + recall)
    return {"precision": precision, "recall": recall, "f1": f1, "support": tp + fn}


def latency_metrics(values_ms: list[float]) -> dict[str, float | int | None]:
    return {"sampleCount": len(values_ms), "medianMs": median(values_ms) if values_ms else None, "p95Ms": percentile(values_ms, .95), "p99Ms": percentile(values_ms, .99)}
