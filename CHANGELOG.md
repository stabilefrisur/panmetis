# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

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
