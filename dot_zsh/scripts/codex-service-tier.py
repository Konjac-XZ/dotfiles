#!/usr/bin/env python3
"""Set Codex's default service tier while preserving the rest of config.toml."""

import os
import re
import stat
import sys
import tempfile
import tomllib
from pathlib import Path


SETTING = re.compile(
    r'''([ \t]*(?:service_tier|"service_tier"|'service_tier')[ \t]*=[ \t]*)'''
    r'''(?:"(?:\\.|[^"\\])*"|'[^']*')(?=[ \t]*(?:\#|\r?$))'''
)
TABLE = re.compile(r"[ \t]*\[")


def updated_config(contents: str, tier: str) -> str:
    original = tomllib.loads(contents)
    if "service_tier" in original and not isinstance(original["service_tier"], str):
        raise ValueError("top-level service_tier must be a string")

    lines = contents.splitlines(keepends=True)
    found = False
    for index, line in enumerate(lines):
        if TABLE.match(line):
            break
        match = SETTING.match(line)
        if match:
            lines[index] = line[: match.start(0)] + match.group(1) + f'"{tier}"' + line[match.end(0) :]
            found = True
            break

    if original.get("service_tier") is not None and not found:
        raise ValueError("cannot locate top-level service_tier assignment")
    if not found:
        newline = "\r\n" if "\r\n" in contents else "\n"
        lines.insert(0, f'service_tier = "{tier}"{newline}')

    result = "".join(lines)
    if tomllib.loads(result).get("service_tier") != tier:
        raise ValueError("could not safely update top-level service_tier")
    return result


def main() -> None:
    path = Path(sys.argv[1])
    tier = "fast" if sys.argv[2] == "1" else "default"
    contents = path.read_bytes().decode("utf-8") if path.exists() else ""
    result = updated_config(contents, tier)
    if result == contents:
        return

    path.parent.mkdir(parents=True, exist_ok=True)
    mode = stat.S_IMODE(path.stat().st_mode) if path.exists() else 0o600
    temp_path = None
    try:
        with tempfile.NamedTemporaryFile(dir=path.parent, delete=False) as temp:
            temp_path = temp.name
            os.fchmod(temp.fileno(), mode)
            temp.write(result.encode("utf-8"))
            temp.flush()
            os.fsync(temp.fileno())
        os.replace(temp_path, path)
    finally:
        if temp_path and os.path.exists(temp_path):
            os.unlink(temp_path)


if __name__ == "__main__":
    try:
        main()
    except (OSError, UnicodeError, ValueError, tomllib.TOMLDecodeError) as error:
        print(f"codex: could not update config.toml: {error}", file=sys.stderr)
        sys.exit(1)
