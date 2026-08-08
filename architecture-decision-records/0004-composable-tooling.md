# ADR 0004 — Composable Tooling

## Status

Accepted

## Context

A development environment is easier to understand, maintain, and evolve when each component has a clearly defined responsibility.

Rather than relying on monolithic applications, Atelier is built by composing specialized tools that integrate naturally with one another.

## Decision

Tools are selected primarily for a well-defined responsibility and their ability to integrate naturally with the rest of the environment.

Overlapping functionality is avoided unless it provides a clear improvement to the workflow or resolves an observed friction.

## Consequences

- Each tool has a clearly identifiable responsibility.
- Responsibilities belong to the tool that naturally owns it.
- Redundant functionality is avoided whenever practical.
- Integrations should strengthen the environment without blurring tool responsibilities.
