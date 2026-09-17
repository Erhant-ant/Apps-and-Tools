# Changelog

All notable changes to this project will be documented in this file.

## v2 - 2026-07-09
### Added
- Input validation for:
  - total meal price (must be > 0)
  - tip percentage (10, 12, or 15)
  - split count (must be >= 1)
- Clear and user-friendly error messages
- `.gitignore` file for Python/environment/editor artifacts

### Changed
- Refactored calculation logic into reusable helper functions
- Improved console output formatting (currency with 2 decimals)
- Updated `README.md` with new behavior and examples

## v1 - 2025-10-26
### Added
- Initial tip calculator implementation
- Basic tip calculation and bill split flow
- Initial `README.md`
- `gitignore.txt` (later replaced by `.gitignore` in v2)