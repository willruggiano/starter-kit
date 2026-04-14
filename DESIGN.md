# Design Document: Nix-Based Starter Kit Templates for Solo Dev + Coding Agents

## Status

Draft for implementation handoff.

This document is future-state oriented, but it also defines a tighter v1
implementation contract than the previous draft.

## Audience

Coding agent implementing this flake repository and the templates it exports.

## Purpose

This repository is not a literal GitHub repository template.

It is a Nix flake that publishes one or more starter templates which can be
instantiated with commands such as:

```bash
nix flake init -t github:willruggiano/starter-kit#default
```

The generated repository is the governed control plane for a new personal
project.

This design is explicitly optimized for:

- Nix-enabled machines
- personal projects
- solo development with coding agents

It is not optimized for portability to non-Nix environments.

---

# 1. Problem statement

We want a starter kit that makes the following properties the default:

1. deterministic developer and agent environments
2. canonical project memory in versioned repo artifacts
3. machine-validated task metadata
4. Nix-defined formatting, validation, hooks, and helper commands
5. task-scoped agent execution with a real sandbox boundary
6. reproducible project bootstrapping via flake templates

The repository should make the governed path obvious and easy for a Nix user,
without carrying compatibility layers for non-Nix workflows.

---

# 2. Goals

## Primary goals

1. Publish a `templates` output that can bootstrap new project repositories.
2. Define all operational behavior in Nix.
3. Make `nix flake check` the authoritative validation entrypoint.
4. Use `treefmt-nix` for formatting and `git-hooks.nix` for Git hooks.
5. Define agent runtimes and their sandboxes as Nix packages/apps.
6. Keep v1 small, coherent, and honest about what is actually enforced.

## Secondary goals

1. Preserve room for stronger sandboxing backends later.
2. Keep generated repositories readable and easy to modify.
3. Avoid dead scaffolding for future-only artifacts.
4. Optimize for personal use rather than broad ecosystem adoption.

## Non-goals

1. Supporting non-Nix machines.
2. Shipping a `scripts/` directory as the operational interface.
3. Using GitHub repository-template mechanics as the primary distribution path.
4. Requiring Node/npm bootstrap outside of Nix.
5. Claiming perfect sandboxing or complete policy enforcement in v1.
6. Building a general autonomous orchestrator service in v1.

---

# 3. Core principles

1. Artifacts are canonical: durable project memory lives in repo files.
2. Nix is mandatory, not optional.
3. Enforcement should come from Nix-defined checks, apps, and sandboxes.
4. Generated repos should expose a small number of obvious entrypoints.
5. V1 should only require artifacts and policies that actually exist.
6. Stronger isolation should be possible later without redesigning the repo.
7. The design should optimize for the repo owner, not generic consumers.

---

# 4. Primary user experience

The intended workflow is:

1. inspect available templates with `nix flake show`
2. create a new repo with `nix flake init -t ...#default`
3. enter the environment with `nix develop`
4. format with `nix fmt`
5. validate with `nix flake check`
6. run helper operations through `nix run .#<app>`

There should be no parallel shell-script-first workflow in v1.

---

# 5. What this repository ships

The source repository should provide:

1. a flake with `templates` outputs
2. a Nix-defined dev shell for working on the starter kit itself
3. Nix-defined checks for the starter kit itself
4. shared Nix code used by the exported templates
5. at least one production-ready starter template

The primary template should be named `default`.

---

# 6. Flake output contract

The source flake should expose at least:

- `templates.default`
- `devShells`
- `formatter`
- `checks`

Generated project flakes should expose at least:

- `devShells.default`
- `formatter`
- `checks`
- `apps`
- `packages`

`nix run .#<app>` is the command surface for helper operations that would
otherwise have been shell scripts.

---

# 7. Repository architecture

The source repository should be organized around Nix modules and template
directories rather than ad hoc shell utilities.

Recommended top-level shape:

```text
.
├── README.md
├── DESIGN.md
├── flake.nix
├── flake.lock
├── nix/
│   ├── lib/
│   ├── checks/
│   ├── hooks/
│   ├── apps/
│   └── sandboxes/
└── templates/
    └── default/
```

This exact layout is adjustable, but v1 should not reintroduce:

- `scripts/`
- `.githooks/`
- `package.json`
- `package-lock.json`

unless a concrete template requirement justifies them and that requirement is
still fully managed by Nix.

---

# 8. Template model

Each exported template is a complete flake-based repository skeleton.

That means each template must include its own:

- `flake.nix`
- project docs
- control-plane artifacts
- Nix-defined checks, formatting, hooks, and apps

The generated repository should be usable immediately after `nix flake init`
with only project-specific content needing replacement.

## V1 template scope

V1 should ship one required template:

- `default`

Future variants may include:

- a stronger-isolation template based on `microvm.nix`
- a container-oriented template
- specialized language or deployment templates

Those future variants are not required for v1.

---

# 9. Nix requirements

Nix is first-class in the strongest sense:

1. all tooling needed for the governed workflow must come from Nix
2. all validation entrypoints must be flake outputs
3. hooks must be defined in Nix
4. formatting must be defined in Nix
5. helper commands must be exposed as Nix apps
6. agent runtime packaging must be defined in Nix

The implementation does not need to support users who do not have Nix.

---

# 10. Formatting

Formatting must be defined with `treefmt-nix`.

## Requirements

1. `nix fmt` is the canonical formatting command.
2. formatting checks run as part of `nix flake check`.
3. formatter configuration should live in Nix, not as a separately hand-managed
   formatter stack when `treefmt-nix` can own it.

The exact formatter set is an implementation choice, but it should cover the
languages and file types shipped by the template.

---

# 11. Git hooks

Git hooks must be defined and generated with `cachix/git-hooks.nix`.

## Requirements

1. hooks are declared in Nix
2. hook installation is driven from the Nix development environment
3. hook logic should reuse the same checks that power `nix flake check`
4. v1 should not ship handwritten hook scripts

The happy path should be that entering `nix develop` makes hooks easy to install
or installs them automatically if the chosen integration makes that practical.

---

# 12. Validation architecture

`nix flake check` is the authoritative validation path.

## Required checks

At minimum, the generated template should check:

1. formatting
2. control-plane schema validity
3. basic template integrity
4. any documented task-policy checks that are actually implemented in v1

There should not be a second, competing validation contract based on handwritten
shell scripts.

---

# 13. Control-plane design

The generated repository should keep the typed control plane real but narrow.

## Required v1 artifacts

At minimum:

- `TASKS.json`
- canonical project docs in Markdown
- optional task packet Markdown files if they materially help agent workflows
- `schemas/TASKS.schema.json`

## Not required in v1

The following should not be required unless they actually exist and are
validated:

- `STATE.json`
- milestone JSON artifacts
- run record JSON artifacts
- schemas for future-only machine-readable files

The earlier draft overreached here. V1 should only define and validate what it
actually uses.

## TASKS.json requirements

`TASKS.json` should support a small, useful core model:

- task IDs
- title or summary
- task status
- optional dependencies
- allowed paths for task-scoped work
- acceptance criteria
- verification commands
- optional owner
- optional notes

V1 should prefer an allowlist model for scoped work.

Explicit `forbidden_files` are not required in v1 unless the implementation
chooses to enforce them for real.

## Status model

Recommended v1 statuses:

- `planned`
- `ready`
- `in_progress`
- `implemented`
- `verified`
- `blocked`
- `done`

## Schema strictness

The schema should:

- reject unknown enum values
- require stable task ID formatting such as `T-001`
- require arrays for `allowed_paths`, `acceptance_criteria`, and `verification`
- reject empty required strings where practical

---

# 14. Canonical repo artifacts in generated templates

The default template should include a coherent minimal document set such as:

- `README.md`
- `PRODUCT_BRIEF.md`
- `ARCHITECTURE.md`
- `DECISIONS.md`
- `CONSTRAINTS.md`
- `STATE.md`
- `TASKS.json`

If task packet Markdown files are included, they should be treated as
human-readable companions to the machine-validated task registry, not as a
second competing source of truth for structured fields.

---

# 15. Agent runtime and helper apps

Helper operations should be exposed as Nix apps rather than shell scripts.

Examples include:

- `task-context`
- `worktree`
- `agent-runner`

V1 does not need all of these if they do not materially improve the baseline,
but any helper that exists should be reachable through `nix run .#<app>`.

## Required direction

The starter kit should define agent runtimes as Nix packages/apps.

That means:

1. runtime dependencies come from Nix
2. execution entrypoints are exposed via flake apps
3. prompts and task metadata are read from repo artifacts
4. sandbox policy is derived from repo state, not from a chat-only convention

Actual model-provider integration is an implementation detail left open for now.

---

# 16. Sandbox design

Agent sandboxes should be defined in Nix.

## V1 default backend

The default v1 sandbox backend should be `jail.nix`.

Rationale:

- it is lighter-weight than VM-backed isolation
- it maps well onto wrapping derivations and apps
- it fits a personal-project starter better than introducing VM complexity first

## Future backends

The design should leave room for:

- `microvm.nix` for stronger isolation
- Nix-built container images runnable with Docker or Podman

Those are future extension paths, not required v1 defaults.

## Enforcement expectation

V1 should be explicit about what the sandbox does and does not enforce.

If task-scoped writable paths are enforced, document exactly how.

If they are not yet enforced, do not claim that they are.

---

# 17. Worktree support

Worktree support is useful, but it should not force a return to handwritten
shell scripts.

If included in v1, it should be exposed as an app such as:

```bash
nix run .#worktree -- T-014
```

If it is not included in v1, that is acceptable as long as the omission is
documented.

---

# 18. README requirements

The source repo README should explain:

- what this repository is
- how to inspect exported templates
- how to instantiate the default template
- what constraints the generated templates assume

The generated template README should explain:

- how to enter the dev shell
- how to format the repo
- how to run validation
- how helper apps are exposed
- what is actually enforced in v1

All documentation should clearly state that this starter kit is Nix-only.

---

# 19. Acceptance criteria

The implementation is complete when all of the following are true.

## Source repo acceptance criteria

1. `nix flake show` exposes the intended templates.
2. The source repo itself has a working Nix-defined formatter and checks.
3. The source repo does not rely on a `scripts/` directory for its primary
   workflow.

## Template acceptance criteria

1. `nix flake init -t .#default` from a local checkout produces a coherent
   starter repository in an empty directory.
2. The generated repository has a working `nix develop`.
3. `nix fmt` works in the generated repository.
4. `nix flake check` passes on the clean generated repository.
5. Formatting is implemented through `treefmt-nix`.
6. Hooks are implemented through `git-hooks.nix`.
7. `TASKS.json` is validated against a real schema that ships with the template.
8. Any helper entrypoints that ship are exposed via `nix run .#<app>`.
9. Any sandboxed agent runner that ships is defined in Nix.
10. The generated repository does not claim stronger enforcement than it
    actually implements.

---

# 20. Open design choices left to implementer

The coding agent may choose the exact implementation details for:

1. the internal Nix module layout
2. the exact formatter set inside `treefmt-nix`
3. the exact hook set inside `git-hooks.nix`
4. the exact JSON Schema validation tool used inside Nix
5. whether the default template includes helper apps beyond validation and
   formatting
6. the exact task metadata shape beyond the required core fields
7. the exact provider integration strategy for the agent runtime

When making these choices, prefer the smallest complete implementation.

---

# 21. Risks and guidance

## Risk: carrying obsolete shell-first assumptions

Do not preserve shell-script interfaces just because the previous draft had
them.

If a helper is worth shipping, expose it as a Nix app.

## Risk: dead schema and dead artifact sprawl

Only require schemas and machine-readable files that are actually used in v1.

## Risk: fake sandboxing

Do not imply that a prompt, doc, or naming convention is a sandbox.

Only claim enforcement that comes from the Nix-defined runtime or checks.

## Risk: overbuilding template variants too early

Ship one strong default template first.

Additional variants should only be added when they are clearly justified.

---

# 22. Recommended implementation phases

## Phase 1: source flake baseline

Implement:

- source repo `flake.nix`
- source repo formatter
- source repo checks
- source repo template export

## Phase 2: default template baseline

Implement:

- self-contained template flake
- canonical docs
- `TASKS.json`
- `schemas/TASKS.schema.json`
- template README

## Phase 3: formatting and hooks

Implement:

- `treefmt-nix`
- `git-hooks.nix`
- working `nix fmt`
- working `nix flake check`

## Phase 4: helper apps and runtime

Implement:

- any required helper apps
- initial agent runtime packaging
- initial sandbox integration using `jail.nix`

## Phase 5: hardening

Implement only if the baseline is already coherent:

- stronger task-policy checks
- optional worktree helper
- optional additional template variants

---

# 23. Definition of done

The coding agent's task is done when:

- this repository acts as a usable flake template source
- the default template can be instantiated locally with `nix flake init`
- the generated repo has a coherent Nix-native workflow
- formatting, hooks, and validation are Nix-defined
- the v1 contract is smaller and more honest than the previous draft

---

# 24. Final instruction to implementer

Implement the smallest complete Nix-native starter kit that satisfies this
document.

Bias toward:

- correctness
- readability
- honest enforcement
- Nix-defined behavior
- a strong default path

Do not bias toward:

- non-Nix compatibility
- multiple overlapping interfaces
- dead future scaffolding
- complexity for its own sake
