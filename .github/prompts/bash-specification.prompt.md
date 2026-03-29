---
description: "Create a complete Bash script specification for new or existing .sh files"
name: "Bash Script Specification"
argument-hint: "Describe the script purpose, inputs, outputs, and constraints"
agent: "agent"
---
Create a detailed Bash script specification from the user request.

Use this prompt when the user wants a spec/requirements document before implementation.

## Inputs To Capture
- Script name (default: `script.sh` if unknown)
- Primary goal and non-goals
- Expected environment (Linux distro, shell path, package manager)
- Required privileges (`sudo` required or not)
- Inputs (flags, arguments, files, stdin)
- Outputs (stdout/stderr format, output files, exit codes)
- Safety constraints (destructive commands, confirmation prompts, idempotency)
- Dependencies (system commands/packages)

## Specification Requirements
Produce a structured spec with the following sections:

1. Overview
- Script purpose in 1-2 sentences
- Success criteria

2. Command Interface
- Usage line(s)
- Supported flags/options (include `-h` and `--help`)
- Argument validation behavior
- Invalid option behavior

3. Runtime Behavior
- Ordered execution flow
- Preconditions and environment checks
- Privilege checks (`EUID`) and behavior if missing permissions
- Dependency checks (`command -v ...`) and user-facing errors

4. Input/Output Contract
- Input schema (arg formats, file formats)
- Output messages (high-level)
- Generated artifacts (filenames/patterns)
- Exit status table (`0`, non-zero with meanings)

5. Reliability and Safety
- Error handling model (`set -euo pipefail` or justified alternative)
- Quoting/word-splitting safeguards
- Cleanup behavior
- Re-run behavior (idempotency expectations)

6. Security and Portability
- Shell target (`/usr/bin/bash` vs `/usr/bin/env bash`)
- Secret handling (never echo secrets)
- Path handling and unsafe input rejection
- Distribution assumptions (Debian/Ubuntu vs generic Linux)

7. Testing and Validation Plan
- Happy-path tests
- Flag parsing tests
- Invalid-input tests
- Permission/dependency failure tests
- Suggested linting (`shellcheck`) and syntax check (`bash -n`)

8. README Update Checklist
- Add/refresh script section
- Add usage examples (`-h` and `--help`)
- Add prerequisites and troubleshooting notes

## Output Format
Return the final specification in Markdown with concise bullet points and command examples.
If any requirement is missing, add an "Open Questions" section at the end with only essential questions.
