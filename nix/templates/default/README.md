# Project Name

<!-- TODO: Replace with your project name and description. -->

A Nix-native project with governed workflows for solo development and coding
agents.

## Requirements

This project requires Nix with flakes enabled. It does not support non-Nix
environments.

## Quick start

```bash
# Enter the development environment
nix develop

# Format all files
nix fmt

# Run all validation checks
nix flake check

# Run the sandboxed coding agent
nix run .#claude-code
```

## What is enforced

`nix flake check` is the authoritative validation entrypoint. It runs:

- **formatting** — `treefmt-nix` with prettier, alejandra, ruff-format, shfmt
- **pre-commit hooks** — deadnix, nil, statix, ruff, shellcheck, actionlint
- **state validation** — `TASKS.json` is validated against
  `schemas/TASKS.schema.json`
- **governance** — required canonical artifacts must exist

## Canonical documents

| Document           | Purpose                           |
| ------------------ | --------------------------------- |
| `README.md`        | Project overview and quick start  |
| `PRODUCT_BRIEF.md` | What the project is and why       |
| `ARCHITECTURE.md`  | How the project is structured     |
| `DECISIONS.md`     | Key decisions and their rationale |
| `CONSTRAINTS.md`   | Hard constraints on the project   |
| `DESIGN.md`        | Detailed design specification     |
| `STATE.md`         | Current project state             |
| `TASKS.json`       | Machine-validated task registry   |

## Development

The development environment is managed entirely through Nix. Enter it with
`nix develop` or use `direnv` by copying `.envrc.template` to `.envrc`.

Helper operations are exposed as Nix apps via `nix run .#<app>`.

## Agent runtime

The sandboxed coding agent is available via `nix run .#claude-code`. It runs
inside a `jail.nix` sandbox with controlled filesystem access, network
permissions, and standard development tooling.
