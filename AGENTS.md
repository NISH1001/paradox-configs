# AGENTS.md

Guide for coding agents working in this repo. Human-facing notes are in `README.md`.

## What this repo is

Personal dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/). The repo
is expected to live at `~/paradox-configs`. It is **public on GitHub**.

Each top-level folder is a stow *package*: its contents mirror paths relative to `~`.
`nvim/.config/nvim/init.lua` becomes `~/.config/nvim/init.lua` after `stow nvim`.

Because the files are symlinked, **editing a file here changes the live config
immediately**. There is no build or install step after an edit.

## Packages

| Package | Notes |
|---|---|
| `shell` | Shared bash + zsh config, in `~/.config/shell/` (see below) |
| `host-<machine>` | One per machine: that machine's `~/.zshrc` and `~/.bashrc` |
| `bash` | `.inputrc` and `.bashrc-linux-legacy` (old single-file Linux bashrc, raw material only) |
| `git`, `just`, `nvim`, `ghostty`, `herdr`, `cheat`, `espanso`, `ruff`, `mpv`, `ranger`, `wtf` | Cross-platform tools |
| `claude` | Claude Code `settings.json` and status line script |
| `i3`, `i3blocks`, `i3-autodisplay`, `sway`, `rofi`, `compton`, `devilspie`, `greenclip`, `PulseEffects`, `mplayer` | Linux desktop only; unused on macOS |

`bin/`, `templates/`, `wallpapers/`, `z.sh` and `my-i3.md` are plain files, not stow packages.

## Shell layout

```
shell/.config/shell/common.sh      shared by both shells: aliases, PATH, functions
shell/.config/shell/zsh.zsh        zsh only (completion, fzf)
shell/.config/shell/bash.bash      bash only (history, prompt, completion, nvm)
shell/.config/shell/os-Darwin.sh   macOS only
shell/.config/shell/os-Linux.sh    Linux only
host-m3-max/.zshrc, .bashrc        source the files above, then machine-specific lines
```

Where a new line goes:

- Wanted on every machine, in both shells: `common.sh`.
- Specific to one shell or one OS: the matching file above.
- Specific to one machine (work aliases, project paths, one-off tools): that machine's `host-*` file.

Rules for the shared files:

- `common.sh` and `os-*.sh` must run in **both zsh and bash 3.2** (the macOS system bash). No
  zsh-only or bash-4-only syntax.
- Guard anything that depends on an installed tool or an existing directory
  (`command -v x >/dev/null 2>&1 && ...`, `[ -d ... ] && ...`), so the file is a no-op where
  the tool is missing.
- Never hardcode a home directory. Use `$HOME` in shell files and `~` in config files.
- Keep startup fast. zsh currently starts in about 0.3 s; do not add an `eval "$(tool init)"`
  without measuring it (`time zsh -ilc exit`).

Installers that append to `~/.zshrc` or `~/.bashrc` write into the `host-*` file. Treat such
lines as an inbox: move anything generally useful to the shared files, and replace absolute
paths with `$HOME`, before committing.

## Stowing

```bash
stow shell just git nvim ghostty herdr cheat bash host-m3-max
mkdir -p ~/.claude && stow --no-folding -t ~ claude
```

- `claude` **must** use `--no-folding` with `~/.claude` already existing. Otherwise stow links
  the whole directory and Claude Code writes its history, sessions and caches into this repo.
- `herdr` links only `config.toml`; `~/.config/herdr/` is a real directory holding runtime
  logs and sockets. Leave it that way.
- Stow exactly one `host-*` package per machine. They all provide `~/.zshrc`, so two conflict.
- A new machine needs its own `host-<name>/` first: copy `host-m3-max/`, keep the `source`
  lines, drop the machine-specific section.
- When moving or renaming a file inside a package, run `stow -D <package>` before the move
  and `stow <package>` after, so no dangling symlink is left in `~`.

## Checking your work

There is no test suite. After a change:

- Shell files: `zsh -n <file>` and `bash -n <file>`, then start a fresh shell
  (`zsh -ic exit`, `bash -ic exit`) and confirm it prints no errors.
- Links: `stow -n -v <package>` should report nothing to do.
- JSON and TOML configs: parse them before committing.

## Known gotchas

- `~/.claude/settings.json` can stop being a symlink: Claude Code sometimes replaces it with a
  regular file when it saves. If repo and live settings disagree, check `ls -la` on it first.
  Re-link by copying the live file over the repo copy, deleting the live one, and re-stowing.
- `claude/.claude/settings.json` may contain machine-specific content (local project paths in
  the `autoMode` block). Review before committing.
- `bash/.bashrc-linux-legacy` is not sourced by anything. Do not add new config to it.

## Commits

- Message style: `<package>: <short summary>`, for example `nvim: add markdown stack`.
- One logical change per commit; keep unrelated packages in separate commits.
- The repo is public. Never commit secrets, tokens or private hostnames. `bash/.secrets` is
  gitignored for that purpose.
- Commit and push only when asked.
