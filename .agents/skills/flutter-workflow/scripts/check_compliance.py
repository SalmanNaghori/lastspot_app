#!/usr/bin/env python3
"""Partial, heuristic Flutter checks; complete the architecture matrix separately.

Run from the app root with Python 3.10+:
python3 .agents/skills/flutter-workflow/scripts/check_compliance.py --base HEAD
The base is compared with the working tree (including staged and untracked lib files).
Exit 0: no candidates in these checks; 1: review candidates; 2: check could not run.
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

_GENERATED = (".g.dart", ".freezed.dart", ".gr.dart")
_CHECKS = (
    ("ERR-6", re.compile(r"\bprint\s*\(")),
    ("ERR-3", re.compile(r"\bcatch\s*\([^)]*\)\s*\{\s*\}")),
    ("SEC-1", re.compile(r"AIza[0-9A-Za-z_-]{30,}|Bearer [A-Za-z0-9._-]{20,}")),
)
_HANDLER = re.compile(r"\bFlutterError\s*\.\s*onError\s*=(?!=)")


def git(*args: str) -> bytes:
    return subprocess.run(["git", *args], check=True, capture_output=True, timeout=30).stdout


def added_lines(diff: str) -> list[tuple[int, str]]:
    result = []
    line_number = 0
    in_hunk = False
    for line in diff.splitlines():
        if line.startswith("@@ "):
            match = re.match(r"@@ -\d+(?:,\d+)? \+(\d+)", line)
            if match:
                line_number = int(match[1])
                in_hunk = True
        elif in_hunk and line.startswith("+"):
            result.append((line_number, line[1:]))
            line_number += 1
        elif in_hunk and line.startswith(" "):
            line_number += 1
    return result


def check(base: str) -> int:
    app_root = Path.cwd().resolve()
    git_root = Path(git("rev-parse", "--show-toplevel").decode().strip()).resolve()
    app_prefix = app_root.relative_to(git_root).as_posix()
    lib_prefix = "lib/" if app_prefix == "." else f"{app_prefix}/lib/"
    git("rev-parse", "--verify", f"{base}^{{commit}}")
    changed = git("diff", "--no-relative", "--name-only", "-z", base, "--", "lib/")
    untracked = git("ls-files", "--others", "--exclude-standard", "--full-name", "-z", "--", "lib/")
    untracked_names = {name.decode() for name in untracked.split(b"\0") if name}
    names = {name.decode() for name in changed.split(b"\0") if name} | untracked_names
    failures = 0
    changed_handler = False
    for name in sorted(names):
        if (
            not name.startswith(lib_prefix)
            or not name.endswith(".dart")
            or name.endswith(_GENERATED)
        ):
            continue
        path = git_root / name
        if path.is_symlink():
            raise ValueError("Symlinked Dart input needs manual review")
        if name in untracked_names:
            lines = list(enumerate(path.read_text(encoding="utf-8").splitlines(), 1))
        else:
            relative = path.relative_to(app_root).as_posix()
            diff = git("diff", "--no-ext-diff", "--no-textconv", "-U0", base, "--", relative)
            lines = added_lines(diff.decode())
        for number, line in lines:
            if line.lstrip().startswith("//"):
                continue
            changed_handler |= bool(_HANDLER.search(line))
            for rule, pattern in _CHECKS:
                if pattern.search(line):
                    # Never echo source: a candidate may contain a credential.
                    print(f"REVIEW {rule} {name}:{number}")
                    failures += 1
    if changed_handler:
        assignments = 0
        for path in sorted(Path("lib").rglob("*.dart")):
            if path.is_symlink():
                raise ValueError("Symlinked Dart input needs manual review")
            if path.name.endswith(_GENERATED):
                continue
            assignments += sum(
                len(_HANDLER.findall(line))
                for line in path.read_text(encoding="utf-8").splitlines()
                if not line.lstrip().startswith("//")
            )
        if assignments > 1:
            print("REVIEW ERR-5 multiple FlutterError.onError assignments across lib/")
            failures += 1
    print("Partial static checks only; complete the compliance matrix and Flutter verification.")
    return 1 if failures else 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--base", required=True, help="Explicit base commit/ref; compared to worktree"
    )
    args = parser.parse_args()
    if args.base.startswith("-"):
        parser.error("base must be a commit/ref, not a Git option")
    try:
        return check(args.base)
    except (OSError, UnicodeError, ValueError, subprocess.SubprocessError):
        print(
            "Compliance check could not run; verify Git base, readable files and app root.",
            file=sys.stderr,
        )
        return 2


if __name__ == "__main__":
    sys.exit(main())
