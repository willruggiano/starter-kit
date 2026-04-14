# starter-kit

This repository is the source flake for a Nix-native starter kit for solo
development with coding agents.

The repo is currently dogfooding the same control-plane artifacts that the
future exported template will eventually ship. The template export remains
deferred until the workflow feels coherent in this repository itself.

## Current workflow

Use the source repo directly with:

```bash
nix develop
nix fmt
nix flake check
```

`nix flake check` is the authoritative validation path.

## Current scope

The repository currently contains:

- the source flake and source-repo Nix wiring
- canonical project docs
- a machine-validated `TASKS.json`
- Nix-defined checks for control-plane validation and repo integrity

It does not yet export a `default` starter template.

## Canonical docs

The current canonical docs are:

- `README.md`
- `PRODUCT_BRIEF.md`
- `ARCHITECTURE.md`
- `DECISIONS.md`
- `CONSTRAINTS.md`
- `STATE.md`
- `TASKS.json`
- `DESIGN.md`

## Near-term direction

1. Dogfood the instantiated-repo workflow in this source repo.
2. Tighten the control plane and validation path.
3. Export a `default` template only after the in-repo workflow is credible.
