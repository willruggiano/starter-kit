# Nix-native starter kit source flake

Nix is just absolutely fantastic for corralling coding agents.

This repository is a work-in-progress template that consolidates my personal
experiences setting up Nix-based development environments that "play nice" with
coding agents.

## Why even care?

Coding agents work best if you let them rip in YOLO mode. They make mistakes,
they adjust, they iterate. Eventually (usually) they produce something that
resembles code.

Of course, you can't just rip in YOLO mode. I commend the efforts of the
claude-codes, codexes, and others of the world for valiantly trying to solve the
(admittedly hard) problem of sandbox isolation. That being said, sorry guys. I
don't trust you. Not one bit.

That's where this project comes in. The goal: use Nix to do what Nix does best
and create a deterministic, systematically isolated jail for my coding agents.
YOLO baby.

## Usage

```bash
# See what's available
nix flake show github:willruggiano/starter-kit

# Bootstrap a new project
nix flake init -t github:willruggiano/starter-kit#default
```

## What you get

A Nix-native project scaffold with:

- `nix develop` — deterministic dev shell
- `nix fmt` — treefmt-nix formatting
- `nix flake check` — pre-commit hooks, linting, schema validation
- `nix run .#claude-code` — sandboxed coding agent via jail.nix

## Requirements

Nix with flakes enabled. Nothing else.
