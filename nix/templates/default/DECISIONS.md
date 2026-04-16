# Decisions

## Nix-first, no portability layer

**Date**: project inception

This project uses Nix as the sole operational interface. There is no
shell-script fallback, no npm/package.json bootstrap, and no support for non-Nix
machines.

**Rationale**: Nix gives deterministic environments, reproducible validation,
and a single source of truth for tooling. Portability layers add complexity
without value for a personal project on Nix-enabled machines.

<!-- TODO: Add project-specific decisions below. -->
