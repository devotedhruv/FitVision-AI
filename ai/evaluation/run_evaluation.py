"""Validate anonymous JSON annotations and emit measured metrics as JSON."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from evaluation_metrics import count_metrics, latency_metrics


def evaluate(dataset: Path, schema_path: Path) -> dict:
    schema = json.loads(schema_path.read_text())
    samples = json.loads(dataset.read_text())
    if not isinstance(samples, list):
        raise ValueError("Dataset must be a JSON array")
    seen: set[str] = set()
    for sample in samples:
        annotation = sample.get("annotation")
        if not isinstance(annotation, dict):
            raise ValueError("Each sample requires an annotation object")
        missing = set(schema["required"]) - set(annotation)
        unknown = set(annotation) - set(schema["properties"])
        if missing or unknown:
            raise ValueError(f"Invalid annotation fields; missing={sorted(missing)}, unknown={sorted(unknown)}")
        for name in ("expectedCompleteRepCount", "expectedIncompleteRepCount"):
            if not isinstance(annotation[name], int) or annotation[name] < 0:
                raise ValueError(f"{name} must be a non-negative integer")
        for name in ("exerciseType", "split", "cameraPosition", "distanceCategory", "lightingCategory", "repetitionSpeed"):
            allowed = schema["properties"][name]["enum"]
            if annotation[name] not in allowed:
                raise ValueError(f"Unsupported {name}")
        sample_id = annotation["sampleId"]
        if sample_id in seen:
            raise ValueError(f"Duplicate anonymous sample ID: {sample_id}")
        seen.add(sample_id)
    expected = [item["annotation"]["expectedCompleteRepCount"] for item in samples]
    actual = [item["prediction"]["completeRepCount"] for item in samples]
    latencies = [value for item in samples for value in item["prediction"].get("frameLatenciesMs", [])]
    return {"repCount": count_metrics(expected, actual).__dict__, "latency": latency_metrics(latencies), "sampleIds": sorted(seen)}


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("dataset", type=Path)
    parser.add_argument("--schema", type=Path, default=Path(__file__).parent / "schemas/annotation.schema.json")
    args = parser.parse_args()
    print(json.dumps(evaluate(args.dataset, args.schema), indent=2, sort_keys=True))
