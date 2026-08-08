# ADR 0003 — Adoption of the XDG Base Directory Specification

## Status

Accepted

## Context

Atelier aims to provide a coherent environment across macOS and Arch Linux while minimizing clutter in the home directory.

## Decision

The XDG Base Directory Specification is adopted whenever it is supported.

Exceptions are documented explicitly.

## Consequences

- Configuration is stored in `~/.config`.
- Data is stored in `~/.local/share`.
- State is stored in `~/.local/state`.
- Cache is stored in `~/.cache`.

Platform-specific exceptions are documented where necessary.
