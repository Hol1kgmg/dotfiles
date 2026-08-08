# Project Overview
Dotfiles management project for macOS development environment using Nix and Home-Manager

# Setup and Basic Usage
Setup instructions and basic usage are documented in [README.md](./README.md).

# Directory Structure
See [DIRECTORY_STRUCTURE.md](./DIRECTORY_STRUCTURE.md) for details.

# Troubleshooting
- Setup and daily usage issues: See [SETUP_TROUBLESHOOTING.md](./SETUP_TROUBLESHOOTING.md)

# Work Rules
1. Propose implementation plan
2. Wait for approval
3. Start implementation

# Tool Usage Policy
**Prefer dedicated tools for file operations by default** (not enforced via `permissions.deny` — occasional Bash use is fine when it's genuinely more convenient):
- `ls`, `find` → `Glob` tool
- `cat`, `head`, `tail` → `Read` tool
- `grep` → `Grep` tool
- `sed`, `awk` → `Edit` tool
- File writing → `Write` tool
- `curl` → `WebFetch` tool

# Language Settings
- Responses: Japanese
- Thinking: English (for token reduction)
