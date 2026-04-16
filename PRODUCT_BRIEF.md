# Product Brief

## Summary

Build a Nix-native starter kit for personal projects that combine solo
development and coding-agent execution.

## Problem

Typical repository templates treat agent workflow, validation, and environment
setup as optional layers. This starter kit wants those behaviors to be
first-class and reproducible.

## Intended user

The repo owner starting personal greenfield projects on Nix-enabled machines.

## Current product shape

This repository is the source flake that will eventually publish one or more
starter templates. Before that happens, it is also the first dogfooded consumer
of the control-plane model.

## Success criteria

- the source repo itself uses the intended canonical docs and typed task model
- `nix flake check` validates both tooling and control-plane artifacts
- the resulting workflow is credible enough to freeze into a reusable template
