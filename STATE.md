# State

## Current status

The source flake baseline exists and validates. The dogfood pass is complete.
The `default` template is exported and can be instantiated with
`nix flake init -t .#default`.

## Completed

- source flake scaffold
- `treefmt-nix` formatter wiring
- `git-hooks.nix` pre-commit wiring
- canonical repo docs
- typed `TASKS.json` with schema validation
- Nix-native control-plane checks (state, governance)
- agent runtime packaging (`claude-code` with `jail.nix` sandbox)
- exported `default` template

## In progress

- end-to-end template verification

## Deferred

- stronger `governance` policy checks (OPA)
- optional worktree helper
- additional template variants
