# starter-kit

This repository is the source flake for a Nix-native starter kit for solo
development with coding agents.

## Using the template

Inspect available templates:

```bash
nix flake show github:willruggiano/starter-kit
```

Create a new project:

```bash
mkdir my-project && cd my-project
nix flake init -t github:willruggiano/starter-kit#default
git init && git add -A
```

The generated repository is immediately usable:

```bash
nix develop     # enter the development environment
nix fmt         # format all files
nix flake check # run all validation checks
nix run .#claude-code # run the sandboxed coding agent
```

## What the template provides

- Nix-defined development environment with `treefmt-nix` and `git-hooks.nix`
- Machine-validated `TASKS.json` task registry
- Governance checks for required canonical artifacts
- Sandboxed `claude-code` agent runner via `jail.nix`
- Placeholder project docs ready to fill in

## Requirements

This starter kit requires Nix with flakes enabled. It does not support non-Nix
environments.

## Working on this repository

This source repo dogfoods the same control-plane model that the template
exports:

```bash
nix develop
nix fmt
nix flake check
```

`nix flake check` is the authoritative validation path.

## Canonical docs

- `README.md`
- `PRODUCT_BRIEF.md`
- `ARCHITECTURE.md`
- `DECISIONS.md`
- `CONSTRAINTS.md`
- `STATE.md`
- `DESIGN.md`
- `TASKS.json`
