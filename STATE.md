# State

## Current status

The source flake baseline exists and validates.

The repository is now dogfooding the instantiated-repo control plane directly
in-source before any template export is frozen.

## Completed

- source flake scaffold
- `treefmt-nix` formatter wiring
- `git-hooks.nix` pre-commit wiring

## In progress

- canonical repo docs
- typed `TASKS.json`
- Nix-native control-plane checks

## Deferred

- exported `default` template
- helper apps
- agent runtime packaging
- sandbox integration
