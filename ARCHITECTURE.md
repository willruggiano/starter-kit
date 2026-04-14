# Architecture

## Overview

The repository currently has two roles:

1. source flake for the future starter-kit templates
2. dogfooded instance of the intended generated-repo workflow

## Source flake

The source flake is built on:

- `blueprint` for source-repo structure
- `treefmt-nix` for formatting
- `git-hooks.nix` for hook generation

The primary operational entrypoints are:

- `nix develop`
- `nix fmt`
- `nix flake check`

## Control plane

The current dogfooded control plane is intentionally narrow:

- canonical Markdown docs for durable project memory
- `TASKS.json` for typed task metadata
- `schemas/TASKS.schema.json` for validation

## Validation

Validation is Nix-defined and currently includes:

- formatter checks
- pre-commit checks
- control-plane schema validation
- repo integrity checks for required artifacts

## Deferred architecture

The following are intentionally deferred until the dogfooded baseline feels
stable:

- exported flake templates
- helper apps such as `task-context`
- agent runtime packaging
- sandbox integration
