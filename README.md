# Nix-native starter kit source flake

Nix is just absolutely fantastic for corraling coding agents.

This repository is a work-in-progress template that consolidates my personal
experiences setting up Nix-based development environments that "play nice" with
coding agents.

## Why even care?

Coding agents work best if you left them rip in YOLO mode.
They make mistakes, they adjust, they iterate. Eventually (usually) they produce
something that resembles code.

Of course, you can't just rip in YOLO mode. I commend the efforts of the
claude-codes, codexes, and others of the world for valiantly trying to solve the
(admittedly hard) problem of sandbox isolation.
That being said, sorry guys. I don't trust you. Not one bit.

That's where this project comes in.
The goal: use Nix to do what Nix does best and create a deterministic,
systematically isolated jail for my coding agents. YOLO baby.
