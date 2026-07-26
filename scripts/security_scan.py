#!/usr/bin/env python3
"""Fail on likely committed credentials or private evaluation media.

Only rule names and paths are printed; matched credential material is never echoed.
"""

from __future__ import annotations

import re
import subprocess
import argparse
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MEDIA = {".mp4", ".mov", ".avi", ".mkv"}
RULES = {
    "private_key": re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----"),
    "supabase_service_role": re.compile(r"(?:SUPABASE_SERVICE_ROLE_KEY|service_role)\s*[:=]\s*['\"]?[A-Za-z0-9_.-]{24,}"),
    "jwt_secret": re.compile(r"(?:JWT_SECRET|SUPABASE_JWT_SECRET)\s*[:=]\s*['\"]?[^\s'\"]{16,}"),
    "database_url_with_password": re.compile(r"postgres(?:ql)?(?:\+asyncpg)?://[^:\s]+:[^@\s]+@"),
}
ALLOW = {".env.example", "security_scan.py", "secret-management.md"}
ALLOW_PATHS = {"services/api/tests/unit/test_config.py"}


def tracked_files() -> list[Path]:
    output = subprocess.check_output(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z"], cwd=ROOT
    )
    return [ROOT / item.decode() for item in output.split(b"\0") if item]


def historical_findings() -> list[tuple[str, str]]:
    findings: list[tuple[str, str]] = []
    objects = subprocess.check_output(
        ["git", "rev-list", "--objects", "--all"], cwd=ROOT, text=True
    )
    seen: set[str] = set()
    for line in objects.splitlines():
        object_id, _, path = line.partition(" ")
        if (
            not path
            or object_id in seen
            or Path(path).name in ALLOW
            or path in ALLOW_PATHS
        ):
            continue
        seen.add(object_id)
        object_type = subprocess.check_output(
            ["git", "cat-file", "-t", object_id], cwd=ROOT, text=True
        ).strip()
        if object_type != "blob":
            continue
        content = subprocess.check_output(
            ["git", "cat-file", "blob", object_id], cwd=ROOT
        )
        if len(content) > 2_000_000:
            continue
        text = content.decode(errors="ignore")
        for name, pattern in RULES.items():
            if pattern.search(text):
                findings.append((name, f"history:{path}"))
    return findings


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--history", action="store_true")
    args = parser.parse_args()
    findings: list[tuple[str, str]] = []
    for path in tracked_files():
        relative = path.relative_to(ROOT)
        if path.suffix.lower() in MEDIA:
            findings.append(("private_media", str(relative)))
            continue
        if (
            path.name in ALLOW
            or str(relative) in ALLOW_PATHS
            or not path.is_file()
            or path.stat().st_size > 2_000_000
        ):
            continue
        try:
            text = path.read_text(errors="strict")
        except (UnicodeDecodeError, OSError):
            continue
        for name, pattern in RULES.items():
            if pattern.search(text):
                findings.append((name, str(relative)))
    if args.history:
        findings.extend(historical_findings())
    for rule, path in findings:
        print(f"SECURITY_FINDING rule={rule} path={path}")
    if findings:
        return 1
    print("Security scan passed: no tracked private media or recognized credential patterns.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
