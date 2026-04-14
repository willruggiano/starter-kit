# Decisions

## 2026-04-14

### Repository model

This project is a source flake that will publish starter templates. It is not a
GitHub repository template.

### Environment model

The starter kit is Nix-only. Portability to non-Nix machines is not a design
goal.

### Source flake baseline

The source repo uses:

- `blueprint`
- `treefmt-nix`
- `git-hooks.nix`

### Delivery strategy

Dogfood the would-be generated repository directly in the source repo before
committing to exported template structure.
