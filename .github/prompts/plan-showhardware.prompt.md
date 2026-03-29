## Plan: Bash Hardware Inventory Script (`showhardware.sh`)

Maintain and extend `showhardware.sh` as a readable, sudo-gated hardware/system inventory script with Linux-style CLI conventions. The script should provide structured sections, clear operator feedback, and predictable output for troubleshooting and baseline audits.

**Steps**
1. Define script contract and output goals (human-readable hardware/system overview).
2. Keep Linux-style CLI behavior (`-h`, `--help`, invalid-option handling, exit codes).
3. Enforce privilege requirements for commands needing elevated access (`EUID` check).
4. Keep ordered output sections for system, hardware bus, BIOS/enclosure, CPU, memory, disk, and network.
5. Verify command dependencies (`lshw`, `dmidecode`, `lscpu`, `free`, `df`, `ip`) and expected behavior when missing.
6. Preserve clear section separators and readable terminal formatting.
7. Maintain fail-fast safety (`set -e`) so command failures are visible and immediate.
8. Update README usage/prerequisites/troubleshooting whenever command set changes.
9. Validate syntax and runtime behavior with sudo and help-only paths.

**Phase Breakdown and Dependencies**
1. Phase 1: CLI and output contract (steps 1-2).
2. Phase 2: Privilege and dependency model (steps 3 and 5). Depends on Phase 1.
3. Phase 3: Sectioned data collection flow (steps 4 and 6). Depends on Phase 2.
4. Phase 4: Reliability and docs consistency (steps 7-8). Depends on Phase 3.
5. Phase 5: Validation and regression checks (step 9). Depends on all prior phases.

**Relevant files**
- `/home/andreak/src/awk_linux_scripts/showhardware.sh` — primary script implementation.
- `/home/andreak/src/awk_linux_scripts/README.md` — usage, prerequisites, and troubleshooting documentation.
- `/home/andreak/src/awk_linux_scripts/checkforupdates.sh` — style reference for help/argument parsing consistency.

**Verification**
1. Run `bash -n showhardware.sh` for syntax validation.
2. Run `bash showhardware.sh -h` and `bash showhardware.sh --help` to confirm help behavior.
3. Run `bash showhardware.sh --bad-flag` to confirm invalid option handling.
4. Run non-sudo execution to confirm privilege check and user-facing failure message.
5. Run `sudo ./showhardware.sh` and verify all sections print in expected order.
6. Confirm troubleshooting guidance aligns with actual command requirements.

**Decisions**
- Keep output focused on concise terminal-readable diagnostics.
- Keep sudo enforcement explicit and early to avoid partial output confusion.
- Preserve section order and separators for consistent operator experience.
- Keep help output accessible without sudo.

**Further Considerations**
1. Add optional machine-readable mode (for example, JSON summary) for automation.
2. Add command-presence checks with friendly install hints when dependencies are missing.
3. Optionally support selective sections via flags for faster targeted diagnostics.
