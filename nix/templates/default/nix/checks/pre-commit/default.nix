{inputs, ...}: {
  imports = [
    inputs.git-hooks.flakeModule
  ];
  perSystem = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.pre-commit;
  in {
    jail.additionalCombinators = cs:
      with cs; [
        (add-pkg-deps [
          cfg.settings.package
          config.packages.check-governance
          config.packages.check-state
        ])
        (add-pkg-deps cfg.settings.enabledPackages)
        (ro-bind cfg.settings.configPath cfg.settings.configFile)
      ];

    packages = {
      check-governance = pkgs.writeShellApplication {
        name = "check-governance";
        text = ''
          set -euo pipefail

          repo_root="''${1:-.}"

          required_paths=(
            ARCHITECTURE.md
            CONSTRAINTS.md
            DECISIONS.md
            DESIGN.md
            PRODUCT_BRIEF.md
            README.md
            STATE.md
            TASKS.json
            schemas/TASKS.schema.json
          )

          for rel_path in "''${required_paths[@]}"; do
            path="$repo_root/$rel_path"

            if [[ ! -e $path ]]; then
              echo "missing governance artifact: $rel_path" >&2
              exit 1
            fi
          done
        '';
      };

      check-state = pkgs.writeShellApplication {
        name = "check-state";
        runtimeInputs = [
          (pkgs.python3.withPackages (ps: [ps.jsonschema]))
        ];
        text = ''
          python - <<EOF
          import json
          import sys
          from pathlib import Path

          from jsonschema import Draft202012Validator


          def main() -> int:
              """
              Validate governed project state artifacts.
              """

              repo_root = Path(sys.argv[1] if len(sys.argv) > 1 else ".")
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
          EOF
        '';
      };
    };

    pre-commit.settings = {
      hooks = {
        # Formatting
        treefmt = {
          enable = true;
          package = config.packages.treefmt;
        };
        # GitHub Actions
        actionlint.enable = true;
        # Nix
        deadnix.enable = true;
        statix.enable = true;
        # Python
        ruff.enable = true;
        # Shell
        shellcheck.enable = true;
        # Governance
        governance = {
          enable = true;
          entry = lib.getExe config.packages.check-governance;
          pass_filenames = false;
          language = "system";
        };
        # State validity
        state = {
          enable = true;
          entry = lib.getExe config.packages.check-state;
          pass_filenames = false;
          language = "system";
        };
      };
    };
  };
}
