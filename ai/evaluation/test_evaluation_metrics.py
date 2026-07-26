import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))

from evaluation_metrics import binary_metrics, count_metrics, latency_metrics  # noqa: E402
from run_evaluation import evaluate  # noqa: E402


def test_count_metrics_are_deterministic_and_safe_for_empty_data():
    measured = count_metrics([2, 3, 1], [2, 4, 0])
    assert measured.exact_agreement_rate == 1 / 3
    assert measured.mean_absolute_error == 2 / 3
    assert count_metrics([], []).mean_absolute_error is None


def test_binary_and_latency_metrics_include_support_and_percentiles():
    assert binary_metrics(9, 1, 1) == {"precision": .9, "recall": .9, "f1": .9, "support": 10}
    assert latency_metrics([1, 2, 3, 4, 100])["p95Ms"] == 100


def test_regression_manifest_validates_and_has_unique_anonymous_ids():
    report = evaluate(ROOT / "test_cases/regression.json", ROOT / "schemas/annotation.schema.json")
    assert report["repCount"]["exact_agreement_rate"] == 1
    assert report["sampleIds"] == ["synthetic_curl_full", "synthetic_squat_hold"]


def test_reference_rule_snapshots_are_versioned_and_safe():
    for exercise in ("squat", "curl", "pushup"):
        rule = json.loads((ROOT.parent / "reference_rules" / f"{exercise}_rules.json").read_text())
        assert rule["ruleVersion"] == "1.0.0"
        assert 0 <= rule["visibilityThreshold"] <= 1
        assert rule["minimumRepDurationMs"] < rule["maximumRepDurationMs"]
