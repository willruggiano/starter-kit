import json
import sys
from pathlib import Path

from jsonschema import Draft202012Validator


def main() -> int:
    """
    Validate governed project state artifacts.
    """

    repo_root = Path(sys.argv[1])
    tasks_path = repo_root / "TASKS.json"
    schema_path = repo_root / "schemas" / "TASKS.schema.json"

    with schema_path.open("r", encoding="utf-8") as f:
        schema = json.load(f)

    with tasks_path.open("r", encoding="utf-8") as f:
        data = json.load(f)

    Draft202012Validator.check_schema(schema)
    validator = Draft202012Validator(schema)
    errors = sorted(
        validator.iter_errors(data), key=lambda err: list(err.absolute_path)
    )

    if not errors:
        return 0

    for err in errors:
        path = ".".join(str(part) for part in err.absolute_path) or "<root>"
        print(f"{path}: {err.message}", file=sys.stderr)

    return 1


if __name__ == "__main__":
    raise SystemExit(main())
