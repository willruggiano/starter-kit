# Constraints

## Hard constraints

1. **Nix is mandatory.** All tooling comes from Nix. There is no non-Nix
   fallback.
2. **`nix flake check` is authoritative.** It is the single validation
   entrypoint. There is no competing shell-script validation path.
3. **Formatting and hooks are Nix-defined.** `treefmt-nix` owns formatting.
   `git-hooks.nix` owns pre-commit hooks.
4. **No handwritten shell-script control plane.** Helper operations are Nix
   apps, not loose scripts.

## Quality constraints

1. Do not claim enforcement that does not exist. The sandbox uses `jail.nix`,
   not VM-level isolation.
2. Only require schemas and artifacts that are actually validated.
3. Prefer the smallest coherent implementation over speculative abstractions.

<!-- TODO: Add project-specific constraints below. -->
