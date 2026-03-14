# Devcontainer Improvement Ideas

A non-exhaustive list of tooling ideas to push `dev-dots` toward the "ultimate" developer container.
Focused exclusively on tools — nothing here adds a new programming language.

---

## Shell & History

| Tool | What it does | Why add it |
|------|-------------|-----------|
| [atuin](https://github.com/atuinsh/atuin) | Replaces shell history with a SQLite store; full-text search, statistics, optional encrypted sync across machines | `Ctrl-R` becomes a first-class experience; much richer than the current `fzf`-over-history binding |
| [mcfly](https://github.com/cantino/mcfly) | Neural-network re-ranking of shell history suggestions based on context | Brings "smart" ordering to history recall — surfaces the right command faster |
| [navi](https://github.com/denisidoro/navi) | Interactive cheatsheet tool; browse, search, and execute pre-written command snippets | Eliminates the "how did I do that again?" problem without leaving the terminal |
| [tealdeer](https://github.com/dbrgn/tealdeer) | Rust rewrite of `tldr`; community-curated simplified man pages rendered inline | Faster than `man` for the 80% case; works offline after the page cache is seeded |
| [thefuck](https://github.com/nvbn/thefuck) | Auto-corrects the previous mistyped command | Recovers from typos and wrong flags without retyping the whole command |
| [pet](https://github.com/knqyf263/pet) | CLI snippet manager backed by TOML files | Keeps project-specific one-liners organised and searchable inside the terminal |
| [gum](https://github.com/charmbracelet/gum) | Charm library for building interactive shell scripts with styled prompts, lists, and spinners | Enables writing polished interactive bash helpers inside the container without Python/Node |
| [direnv](https://github.com/direnv/direnv) | Loads and unloads environment variables automatically when entering/leaving a directory | Cleanly scopes API keys, `PYTHONPATH`, and project settings per directory without polluting the global shell |

---

## File System & Navigation

| Tool | What it does | Why add it |
|------|-------------|-----------|
| [yazi](https://github.com/sxyazi/yazi) | Blazing-fast terminal file manager with async I/O, image previews, and plugin ecosystem | A modern replacement for `ranger`; handles large directories without blocking |
| [broot](https://github.com/Canop/broot) | Interactive tree navigator with fuzzy search and bulk operations | Better than `lt` (eza tree) when you need to act on files, not just list them |
| [xcp](https://github.com/tarka/xcp) | Parallel, progress-aware `cp` replacement | Makes copying large data sets (datasets, model weights) inside the container visually trackable |
| [duf](https://github.com/muesli/duf) | Modern `df` replacement with colour-coded table output | At a glance shows which mount points are full — useful when container storage limits are hit |
| [dust](https://github.com/bootandy/dust) | Intuitive `du` replacement, shows tree of space consumers | Finds what is eating disk space faster than `du -sh *` |
| [ncdu](https://dev.yorhel.nl/ncdu) | Interactive ncurses disk-usage analyser | Available in apt; pairs well with `dust` for interactive drill-down |

---

## Text, Data & JSON

| Tool | What it does | Why add it |
|------|-------------|-----------|
| [yq](https://github.com/mikefarah/yq) | `jq`-compatible processor for YAML, TOML, XML, and JSON | The container already processes a lot of JSON with `jq`; `yq` covers the YAML side (Kubernetes manifests, CI configs, etc.) |
| [miller (`mlr`)](https://github.com/johnkerl/miller) | Swiss-army knife for CSV, TSV, JSON, and NDJSON — filter, sort, stats, reshape | Complements `qsv`; excels at multi-format pipelines and ad-hoc stats in one command |
| [gron](https://github.com/tomnomnom/gron) | Makes JSON greppable by flattening it to `path = value` lines | Perfect companion to `ripgrep` when hunting values deep in nested JSON |
| [fx](https://github.com/antonmedv/fx) | Terminal JSON viewer and interactive processor | Navigate large JSON blobs interactively without loading them in an editor |
| [visidata](https://www.visidata.org) | Terminal spreadsheet / data explorer for CSV, JSON, parquet, and more | Interactive data exploration in the terminal; no Jupyter required for quick tabular inspection |
| [pup](https://github.com/ericchiang/pup) | `jq` for HTML — CSS selector-based HTML parsing in the shell | Useful for scraping or inspecting HTML responses without a full Python script |
| [dasel](https://github.com/TomWright/dasel) | Select and update data in JSON, YAML, TOML, and XML via a unified selector syntax | One tool to rule all config formats; great for scripting config mutations in CI |

---

## System Monitoring & Benchmarking

| Tool | What it does | Why add it |
|------|-------------|-----------|
| [bottom (`btm`)](https://github.com/ClementTsang/bottom) | Cross-platform graphical process/system monitor (CPU, memory, network, disk) | More informative than `htop`; renders as a dashboard with zoomable graphs |
| [procs](https://github.com/dalance/procs) | Modern `ps` replacement with colour, tree view, and Docker container awareness | Easier to scan long process lists; shows port bindings inline |
| [hyperfine](https://github.com/sharkdp/hyperfine) | CLI benchmarking tool with statistical output and warmup runs | Lets you measure shell pipelines and script runtimes rigorously, right in the terminal |
| [tokei](https://github.com/XAMPPRocky/tokei) | Counts lines of code by language across a project | Quick health-check metric; useful before/after large refactors |
| [lnav](https://lnav.org) | Log file navigator — multi-file, real-time, with SQL queries against log lines | Essential when debugging services; makes raw log files as queryable as a database |
| [watchexec](https://github.com/watchexec/watchexec) | Re-runs a command whenever watched files change | Lightweight live-reload without needing a framework; pairs well with tests and builds |
| [entr](https://eradman.com/entrproject/) | Runs arbitrary commands when files change | Even lighter than `watchexec`; available in apt; perfect for reloading scripts |

---

## Network & HTTP

| Tool | What it does | Why add it |
|------|-------------|-----------|
| [xh](https://github.com/ducaale/xh) | Friendly, fast HTTP client (HTTPie-compatible, written in Rust) | Far more readable than raw `curl` for REST API work; built-in JSON highlighting |
| [httpie](https://httpie.io/cli) | Original human-friendly HTTP client | If `xh` is too new, `httpie` is the battle-tested alternative; excellent for API exploration |
| [curlie](https://github.com/rs/curlie) | `curl` with `httpie` syntax sugar | Drops in as `curl` with zero learning curve and pretty output |
| [doggo](https://github.com/mr-karan/doggo) | Modern DNS client with coloured output and DoH/DoT support | Replaces `dig`/`nslookup` for DNS debugging; readable output without format archaeology |
| [bandwhich](https://github.com/imsnif/bandwhich) | Terminal network utilisation tool; shows per-process bandwidth | Identifies which process is saturating the network without leaving the terminal |

---

## Git & Version Control

| Tool | What it does | Why add it |
|------|-------------|-----------|
| [git-absorb](https://github.com/tummychow/git-absorb) | Automatically creates fixup commits for staged changes and absorbs them into the right parent | Keeps history clean during code review cycles without manual `git rebase -i` bookkeeping |
| [git-branchless](https://github.com/arxanas/git-branchless) | Stacked-PR and patch-based workflow tools on top of Git | Enables large-change workflows common in monorepos without rebase pain |
| [onefetch](https://github.com/o2sh/onefetch) | Prints a rich project summary (languages, contributors, recent commits) as ASCII art | Great first command when opening an unfamiliar repo; surfaces key stats at a glance |
| [gitoxide (`gix`)](https://github.com/Byron/gitoxide) | Blazing-fast, memory-safe Git CLI written in Rust | Useful as a drop-in for read-heavy operations (`clone`, `fetch`, `log`) where speed matters |
| [bit](https://github.com/chriswalz/bit) | Git CLI with autocomplete and suggestions | Lowers friction for less-common Git subcommands without opening `lazygit` |

---

## Developer Workflow & Task Running

| Tool | What it does | Why add it |
|------|-------------|-----------|
| [just](https://github.com/casey/just) | Modern `Makefile` replacement with a clean recipe syntax | Replaces per-project shell scripts and `Makefiles`; self-documenting with `just --list` |
| [task (go-task)](https://taskfile.dev) | YAML-based task runner with dependency graph and parallel execution | An alternative to `just` with richer dependency management |
| [act](https://github.com/nektos/act) | Run GitHub Actions workflows locally inside Docker | Speeds up CI iteration dramatically — test workflows without pushing commits |
| [pre-commit](https://pre-commit.com) | Multi-language framework for managing Git pre-commit hooks | Enforces code quality checks before commits land; configured once, runs everywhere |
| [commitizen](https://commitizen-tools.github.io/commitizen/) | Standardises commit messages (Conventional Commits) and automates changelogs | Useful on teams; can generate release notes and bumps version tags automatically |

---

## Security & Secrets

| Tool | What it does | Why add it |
|------|-------------|-----------|
| [age](https://age-encryption.org) | Modern, simple file encryption with small key files | Replaces GPG for most single-file encryption needs; trivial to script |
| [sops](https://github.com/getsops/sops) | Encrypts only values in YAML/JSON/INI/ENV files, leaving keys readable | Ideal for committing encrypted secrets next to config without a separate secrets store |
| [gopass](https://www.gopass.pw) | Team-friendly password manager built on the pass/GPG model | Works well in headless containers; integrates with `age` for key management |
| [trufflehog](https://github.com/trufflesecurity/trufflehog) | Scans git history and files for leaked secrets and credentials | Should run before any `git push`; catches keys accidentally committed to history |
| [gitleaks](https://github.com/gitleaks/gitleaks) | Scans repos and staged files for secrets | Lighter than `trufflehog` for pre-commit use; fast enough to run on every commit |

---

## Documentation & Content

| Tool | What it does | Why add it |
|------|-------------|-----------|
| [glow](https://github.com/charmbracelet/glow) | Renders markdown beautifully in the terminal | Read `README.md` and docs without leaving the terminal or opening a browser |
| [frogmouth](https://github.com/Textualize/frogmouth) | Full TUI markdown browser with navigation history | Goes further than `glow`: lets you click links and browse docs interactively |
| [pandoc](https://pandoc.org) | Universal document converter (Markdown → HTML, PDF, DOCX, EPUB, …) | Essential for any technical writing or report generation workflow inside the container |
| [mdcat](https://github.com/swsnr/mdcat) | Cat for markdown — inline images in supported terminals | Lightweight alternative to `glow` when you just want `cat` but prettier |

---

## Neovim / Editor Enhancements

| Idea | Details |
|------|---------|
| Pre-warm LazyVim plugins at image build time | Run `nvim --headless "+Lazy! sync" +qa` as a `RUN` step so plugins are baked into the image rather than downloaded on first launch — eliminates the cold-start lag |
| Add `nvim-dap` + `dap-ui` to LazyVim extras | Drop-in debugger adapter protocol UI for Python, Node, and Bash debugging inside Neovim |
| Enable `conform.nvim` formatters for Python (`ruff`), shell (`shfmt`), and JSON (`prettier`) | Consistent auto-format on save across all file types without per-project config |
| Pin a `NVIM_APPNAME` environment variable | Allows multiple Neovim configs to coexist (e.g. a minimal `nvim-min` for quick edits alongside the full LazyVim) |
| Ship a `.lazy.lua` overrides file | Provides a project-level escape hatch for disabling plugins that conflict with specific repos |

---

## tmux Improvements

| Idea | Details |
|------|---------|
| [tmux Plugin Manager (tpm)](https://github.com/tmux-plugins/tpm) | Bootstrap `tpm` in the image so plugins can be declared in `tmux.conf` and installed automatically on first attach |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | Persists tmux sessions across container restarts — layouts and running processes are restored |
| [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) | Automatic continuous saving of `tmux-resurrect` state every few minutes |
| [tmux-fzf](https://github.com/sainnhe/tmux-fzf) | Fuzzy-find tmux sessions, windows, and panes | Browse and switch between complex multi-window dev layouts without memorising pane indices |
| Session name in `PS1` | Display the current tmux session name in the prompt so nested sessions are never ambiguous |
| `tdl` layout improvements | Accept an optional `--dir` flag so the layout can be spawned from any directory, not just `$PWD` |

---

## Container & Image Improvements

| Idea | Details |
|------|---------|
| Multi-arch builds (`linux/amd64` + `linux/arm64`) | Makes the image usable on Apple Silicon Macs and ARM-based CI runners without emulation overhead |
| Pin tool versions via build-args | Replace `releases/latest` API calls with explicit `ARG TOOL_VERSION=x.y.z` so builds are reproducible and CVE-traceability is possible |
| Layer-order optimisation | Move rarely-changing layers (R, locale) earlier and fast-moving ones (LazyVim clone, user tools) later to maximise Docker cache hits on rebuilds |
| Separate `devcontainer.json` features for optional tool groups | Use the VS Code Dev Container Features spec (`ghcr.io/devcontainers/features/…`) to make heavyweight optional toolchains (e.g. Java, .NET) opt-in per project rather than baked in |
| `HEALTHCHECK` instruction | Add a `HEALTHCHECK CMD [ "bash", "-c", "nvim --version && uv --version" ]` so orchestrators can detect a broken image early |
| `.devcontainer/.env.example` | Document all environment variables the container expects (API keys, timezone, etc.) so contributors know what to populate |
| GitHub Actions build-and-push workflow | Publish the image to GHCR on every push to `main` so there is always a pre-built image ready for immediate container start |
| Renovate / Dependabot config | Auto-raise PRs when base image (`debian:bookworm-slim`) or pinned tool versions have updates |

---

## AI Workflow Enhancements

| Idea | Details |
|------|---------|
| [aider](https://aider.chat) | AI pair-programmer in the terminal; works with any LLM and understands the full repo via tree-sitter maps | Complements `opencode` and `claude` — different interaction model (commit-oriented) |
| [fabric](https://github.com/danielmiessler/fabric) | Framework of composable AI prompt patterns for common dev tasks (summarise, extract, improve) | Chains LLM calls as Unix pipes; plays naturally with the existing shell workflow |
| [llm](https://github.com/simonw/llm) | CLI for running prompts against many LLM providers; supports plugins for local models | Swiss-army knife for scripting LLM calls without custom API glue code |
| Context injection helpers | A shell function that pipes `git diff HEAD`, `tokei` output, or a file tree into a chosen AI CLI for richer context with one command |
| AI-aware `fzf` preview | A `fzf` binding that sends the selected file to an LLM for a one-line summary shown in the preview pane |

---

## Observability & Profiling

| Tool | What it does | Why add it |
|------|-------------|-----------|
| [py-spy](https://github.com/benfred/py-spy) | Sampling profiler for Python — attaches to a running process with zero code changes | Profile slow Python scripts without `cProfile` boilerplate |
| [memray](https://github.com/bloomberg/memray) | Memory profiler for Python with flamegraph output | Diagnoses memory leaks and unexpected allocations in data pipelines |
| [flamegraph.pl](https://github.com/brendangregg/FlameGraph) | Generate SVG flamegraph visualisations from `perf` or `py-spy` output | Visualise where CPU time is actually spent; SVGs open in any browser |
| [angle-grinder](https://github.com/rcoh/angle-grinder) | Slice, dice, and aggregate log lines with an SQL-like syntax in the terminal | Faster than loading logs into a database for one-off incident analysis |

---

> **Guiding principles when implementing any of the above:**
> 1. Prefer tools installable from a single `curl | sh` or static binary download to keep the Dockerfile clean and reproducible.
> 2. Pin versions via build-args rather than always fetching `latest` to keep builds hermetic.
> 3. Add the tool's primary invocation as a tip in `post-create.sh` so new users discover it immediately.
> 4. If the tool has an fzf-friendly interface (e.g. fuzzy-pick a file), wire it up in `bash/.config/bash/functions`.
