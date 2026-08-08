# Installation Libraries

## Responsibility

The `lib` directory contains libraries shared by Atelier installation scripts.

These libraries provide common building blocks used to implement installation
logic consistently across the project.

They are intentionally small and focused.

## Design Principles

- Libraries provide reusable functions, not workflows.
- Libraries improve consistency, not automation.
- Every function has a single, well-defined responsibility.
- Functions should be predictable, explicit, and side-effect conscious.
- Libraries must never hide important installation logic.

## Philosophy

A library should help scripts express *intent*, not *implementation*.

An installation script should remain understandable without reading the
implementation of the library.

## Responsibilities

Installation libraries may:

- provide consistent logging
- validate preconditions
- inspect the filesystem
- inspect the execution environment
- verify installation state
- provide small, reusable installation primitives

Installation libraries must never:

- install operating system packages
- create missing system directories unless explicitly responsible for doing so
- overwrite user files or directories
- repair unexpected system state
- guess user intent
- make installation decisions on behalf of the caller

## Contracts

Each library defines a contract for a specific installation domain.

For example:

- `install_application.sh` supports application installation modules.
- `install_machine.sh` (future) will support machine provisioning.

A library should only expose functions that naturally belong to its domain.

## Evolution

Livraries evolve by extraction.

A function should be added only when multiple installation scripts reveal the
same responsibility.

Every new helper must remove duplication without removing understanding.

## Installation Script Structure

Application installation scripts follow a common structure.

1. Variables
2. Preconditions
3. Installation
4. Verification

This convention exists to make every installation script immediately familiar to
read and maintain.
