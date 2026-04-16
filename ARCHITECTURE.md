# Architecture

## Overview

The repository has two roles:

1. source flake that publishes starter-kit templates
2. dogfooded instance of the generated-repo workflow

## Source flake

The source flake is built on:

- `flake-parts` for modular flake composition
- `treefmt-nix` for formatting
- `git-hooks.nix` for hook generation
- `llm-agents.nix` for the coding agent runtime
- `jail.nix` for agent sandboxing

The primary operational entrypoints are:

- `nix develop`
- `nix fmt`
- `nix flake check`

## Template architecture

The `default` template is a self-contained flake under `nix/templates/default/`.
It uses `flake-parts` with explicit module imports rather than auto-discovery.

The template exports:

| Output                 | Purpose                                                   |
| ---------------------- | --------------------------------------------------------- |
| `devShells.default`    | Development environment                                   |
| `formatter`            | treefmt-nix wrapper                                       |
| `checks.pre-commit`    | Pre-commit hooks (formatting, linting, schema validation) |
| `packages.claude-code` | Sandboxed coding agent                                    |
| `apps.claude-code`     | Agent execution entrypoint                                |

## Control plane

The control plane is intentionally narrow:

- canonical Markdown docs for durable project memory
- `TASKS.json` for typed task metadata
- `schemas/TASKS.schema.json` for validation

## Validation

Validation is Nix-defined and runs through `nix flake check`:

- **pre-commit** — formatting (treefmt), linting (deadnix, statix, actionlint),
  and schema validation (TASKS.json against its JSON Schema)

## Agent sandbox

The coding agent runs inside a `jail.nix` sandbox defined in
`nix/packages/claude-code/default.nix`. The sandbox provides controlled
filesystem access and standard development tooling. It does not claim VM-level
isolation.
