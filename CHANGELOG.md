# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [0.1.6] - 2026-08-26

### Added

- Add 22 Matt Pocock skills for code review, codebase design, debugging, domain modeling, planning, implementation, research, testing, teaching, triage, and agent workflows.

### Changed

- Standardize the 25-skill bundle and its lockfile on `mattpocock/skills`, including refreshed versions of `grill-me`, `grill-with-docs`, and `improve-codebase-architecture`.
- Strengthen the README, project instructions, release workflow, and skill-sync workflow with explicit sources of truth, isolated updates, artifact inspection, and completion criteria.
- Synchronize the dependency lockfile with the package version.

### Removed

- Remove 30 superseded skills from the previous mixed-source catalog, including document and presentation tooling, visualization and design helpers, and the former Superpowers workflow suite.

### Fixed

- Include skill bundles containing only non-Python files in both the sdist and wheel.

## [0.1.5] - 2026-08-23

### Changed

- Update bundled skills to latest upstream versions.
- Scope skill updates to the universal skills directory and track the skill lockfile.
- Document the universal-only skill update workflow.

## [0.1.4] - 2026-05-14

### Added

- Add 9 new skills from upstream sources.

### Changed

- Update bundled skills to latest upstream versions.
- Simplify update-skills prompt now that copilot-tools.md is upstream.
- Update project guidelines with skill count, symlink, and update workflow.

## [0.1.3] - 2026-03-29

### Added

- Add VS Code Copilot tool mapping reference.
- Add update-skills prompt for refreshing bundled skills.
- Add publish prompt for automated PyPI releases.

### Changed

- Update bundled skills to latest upstream versions.

### Fixed

- Preserve copilot-tools.md across skill updates.

## [0.1.2] - 2026-03-22

### Added

- Add matplotlib and plotly skills.
- Add `.github/copilot-instructions.md` with project guidelines.

## [0.1.1] - 2026-03-19

### Added

- Include 21 agent skills in the published package.

### Fixed

- Configure hatchling to bundle non-Python skill files (`.md`, `.xsd`, scripts).

## [0.1.0] - 2026-03-19

### Added

- Initial release with project scaffolding.
