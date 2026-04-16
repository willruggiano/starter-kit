# Architecture

This project uses a Nix-first architecture where all operational behavior is
defined in Nix.

## Flake outputs

| Output                 | Purpose                        |
| ---------------------- | ------------------------------ |
| `devShells.default`    | Development environment        |
| `formatter`            | treefmt-nix formatting wrapper |
| `checks.pre-commit`    | Git hook validation            |
| `checks.state`         | TASKS.json schema validation   |
| `checks.governance`    | Required artifact presence     |
| `packages.claude-code` | Sandboxed coding agent         |
| `apps.claude-code`     | Agent execution entrypoint     |

## Validation categories

- **state** — validates governed project state artifacts (TASKS.json schema)
- **governance** — validates repository integrity (required artifacts exist)

## Nix module layout

```text
nix/
├── lib/default.nix                   # Shared helpers (mkJailed)
├── formatter.nix                     # treefmt-nix configuration
├── devshell.nix                      # Development shell
├── checks/
│   ├── pre-commit.nix                # git-hooks.nix integration
│   ├── state.nix + state.py          # TASKS.json validation
│   └── governance.nix + governance.sh # Required artifacts
└── packages/claude-code/default.nix  # Sandboxed agent
```

## Sandbox

The coding agent runs inside a `jail.nix` sandbox. This provides:

- controlled filesystem access (mount-cwd, explicit read-write paths)
- network and GPU access for agent operation
- standard development tooling injected via Nix

The sandbox is defined in Nix and enforced at runtime. It does not claim
VM-level isolation.
