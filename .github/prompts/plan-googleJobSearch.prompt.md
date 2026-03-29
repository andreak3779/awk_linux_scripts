## Plan: Bash Google Job Search Links Script

Create a Bash script that supports an optional `-f` switch for CSV input (`./jobsearch.sh -f roles.csv`) and includes Linux-style help flags (`-h`, `--help`). When `-f` is provided, process roles from CSV; when omitted, prompt interactively for a single role. Build two Google `site:` queries (`boards.greenhouse.io` and `myworkdayjobs.com`) for each role and write one HTML file containing clickable search URLs. The script should follow this repo’s shell conventions (`#!/usr/bin/bash`, clear status messages) and avoid unnecessary `sudo` requirements.

**Steps**
1. Define script contract and CLI behavior.
2. Add Linux-style help output via `-h` and `--help` including synopsis, options, and examples.
3. Add optional `-f`/`--file` CSV input handling (example: `./jobsearch.sh -f roles.csv`) and validate file existence/readability.
4. Parse roles from CSV, skipping blank lines and optional header rows.
5. Add interactive fallback role prompt when `-f` is not supplied.
6. Build search queries for both targets and URL-encode each role to produce valid Google `q` values.
7. Generate one HTML output file containing metadata (timestamp, input mode, optional CSV source) and grouped clickable links for every role.
8. Add safe defaults for output naming (timestamped filename) and print final output path for terminal usability.
9. Verify script execution path (`chmod +x`, run from terminal in interactive and `-f` modes, inspect generated HTML) and confirm graceful behavior for invalid options and missing/empty CSV data.

**Phase Breakdown and Dependencies**
1. Phase 1: CLI contract and help surface (steps 1-2).
2. Phase 2: Input handling and role collection (steps 3-5). Depends on Phase 1.
3. Phase 3: Query generation for each role (step 6). Depends on Phase 2.
4. Phase 4: HTML link document assembly (steps 7-8). Depends on Phase 3.
5. Phase 5: Validation (step 9). Depends on all prior phases.

**Relevant files**
- `/home/andreak/src/awk_linux_scripts/checkforupdates.sh` — style reference for shebang, `set -e`, dependency checks, and terminal status messaging.
- `/home/andreak/src/awk_linux_scripts/showhardware.sh` — style reference for formatted sectioned output and robust command gating.
- `/home/andreak/src/awk_linux_scripts/README.md` — update usage/dependency notes for the new script and terminal-run instructions.
- `/home/andreak/src/awk_linux_scripts/jobsearch.sh` — script implementing CSV role input, query construction, and HTML links output.

**Verification**
1. Run `bash -n jobsearch.sh` for syntax validation.
2. Execute `./jobsearch.sh --help` and `./jobsearch.sh -h` to confirm help output renders and exits successfully.
3. Run `chmod +x jobsearch.sh` and execute `./jobsearch.sh` to validate interactive mode.
4. Execute `./jobsearch.sh -f roles.csv` (or `./jobsearch.sh --file roles.csv`) with sample multi-role CSV input.
5. Confirm HTML output contains clickable Greenhouse and Workday links for all resolved roles.
6. Test invalid option behavior to confirm friendly usage guidance.
7. Test missing file path and unreadable CSV paths to confirm helpful error messages.
8. Test an empty CSV (or CSV with only header) to confirm graceful exit with a clear message.

**Decisions**
- Role input method: optional `-f` CSV switch, with interactive fallback when omitted.
- Help surface: support `-h` and `--help` with Linux-style usage documentation.
- Output artifact: single HTML file containing clickable search links for all roles in the CSV.
- Google endpoint choice: `https://www.google.com/search?q=...` as primary query URL.
- Scope includes terminal-runnable script and README usage update.
- Scope excludes fetching and embedding raw Google results HTML.


**Further Considerations**
1. Define expected CSV shape in README (single column `role`, or first column treated as role).
2. Optionally add `xdg-open "$OUTPUT_FILE"` for one-command open after generation on Linux desktops.
