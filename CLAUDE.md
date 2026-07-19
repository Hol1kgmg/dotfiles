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
**Always use dedicated tools for file operations:**
- File reading → `Read` tool
- File search → `Glob` tool
- Content search → `Grep` tool
- File editing → `Edit` tool
- File writing → `Write` tool

**Denied Bash commands:**
The following commands are blocked via Bash by `permissions.deny` in `.claude/settings.json`. Use the dedicated tools above instead.
- `ls`, `find` → `Glob` tool
- `cat`, `head`, `tail` → `Read` tool
- `grep` → `Grep` tool
- `sed`, `awk` → `Edit` tool
- `curl` → `WebFetch` tool

# Language Settings
- Responses: Japanese
- Thinking: English (for token reduction)
