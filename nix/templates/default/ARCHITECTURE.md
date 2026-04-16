# Architecture

This project uses a Nix-first architecture where all operational behavior is
defined in Nix.

## Flake outputs

| Output                 | Purpose                                                   |
| ---------------------- | --------------------------------------------------------- |
| `devShells.default`    | Development environment                                   |
| `formatter`            | treefmt-nix formatting wrapper                            |
| `checks.pre-commit`    | Pre-commit hooks (formatting, linting, schema validation) |
| `packages.claude-code` | Sandboxed coding agent                                    |
| `apps.claude-code`     | Agent execution entrypoint                                |

## Validation

`nix flake check` runs pre-commit hooks that cover:

- **formatting** — treefmt (prettier, alejandra, ruff-format, shfmt)
- **linting** — deadnix, statix, actionlint
- **schema validation** — TASKS.json validated against
  `schemas/TASKS.schema.json`

## Nix module layout

```text
nix/
├── jailed.nix                        # Jail module (sandbox combinators)
├── formatter.nix                     # treefmt-nix configuration
├── devshell.nix                      # Development shell
├── checks/
│   ├── default.nix                   # Check module entry
│   └── pre-commit/default.nix        # git-hooks.nix integration + schema checks
└── packages/
    ├── default.nix                   # Package module entry
    └── claude-code/default.nix       # Sandboxed agent
```

## Sandbox

The coding agent runs inside a `jail.nix` sandbox. This provides:

- controlled filesystem access (mount-cwd, explicit read-write paths)
- network and GPU access for agent operation
- standard development tooling injected via Nix

The sandbox is defined in Nix and enforced at runtime. It does not claim
VM-level isolation.
