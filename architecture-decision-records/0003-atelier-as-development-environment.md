# ADR 0003 — Atelier as the Development Environment

## Status

Accepted

## Context

Atelier is not a traditional software project.

Its purpose is to define and maintain the working environment in which other projects are designed, developed, and maintained.

## Decision

Atelier describes a coherent development environment rather than a fully automated installation process.

The repository captures decisions, configuration, and documentation that define this environment.

Platform-specific differences are acknowledged explicitly rather than hidden behind unnecessary abstractions.

## Consequences

- Documentation is treated as a first-class component of the project.
- Installation remains modular and explicit.
- Common configuration is shared whenever practical.
- Platform-specific adaptations remain local to the affected module.
