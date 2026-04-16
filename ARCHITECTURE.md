# Architecture

## Overview

The repository has two roles:

1. source flake that publishes starter-kit templates
2. dogfooded instance of the generated-repo workflow

## Source flake

The source flake is built on:

- `blueprint` for source-repo module auto-discovery
- `treefmt-nix` for formatting
- `git-hooks.nix` for hook generation
- `llm-agents.nix` for the coding agent runtime
- `jail.nix` for agent sandboxing

The primary operational entrypoints are:

- `nix develop`
- `nix fmt`
- `nix flake check`

## Template architecture

The `default` template is a self-contained flake under `templates/default/`. It
does not use `blueprint` — it uses a standard direct flake with
`nixpkgs.lib.genAttrs` for system iteration.

The template exports:

| Output                 | Purpose                      |
| ---------------------- | ---------------------------- |
| `devShells.default`    | Development environment      |
| `formatter`            | treefmt-nix wrapper          |
| `checks.pre-commit`    | Git hook validation          |
| `checks.state`         | TASKS.json schema validation |
| `checks.governance`    | Required artifact presence   |
| `packages.claude-code` | Sandboxed coding agent       |
| `apps.claude-code`     | Agent execution entrypoint   |

The template's Nix modules mirror the source repo's modules but are adapted for
a standard flake argument style rather than blueprint's module injection.

## Control plane

The control plane is intentionally narrow:

- canonical Markdown docs for durable project memory
- `TASKS.json` for typed task metadata
- `schemas/TASKS.schema.json` for validation

## Validation

Validation is Nix-defined and organized into named categories:

- **state** — validates governed project state artifacts (TASKS.json schema)
- **governance** — validates repository integrity (required artifacts exist)
- **pre-commit** — formatting and linting hooks

## Agent sandbox

The coding agent runs inside a `jail.nix` sandbox defined in
`nix/packages/claude-code/default.nix`. The sandbox provides controlled
filesystem access and standard development tooling. It does not claim VM-level
isolation.
