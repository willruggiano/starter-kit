# Constraints

## Hard constraints

- Nix is mandatory.
- `nix flake check` is the authoritative validation path.
- Formatting and hooks are defined in Nix.
- The repo should not fall back to a handwritten shell-script control plane.

## Current scope constraints

- Template export is deferred.
- Agent runtime packaging is deferred.
- Sandbox integration is deferred.
- The typed control plane is limited to `TASKS.json` in v1 of the dogfood pass.

## Quality constraints

- Only claim enforcement that is actually implemented.
- Prefer the smallest coherent implementation over broad scaffolding.
- Keep future-only files out of the required path until they become real.
