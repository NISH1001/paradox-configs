# paradox-configs
The list of all the configurations I have.

## Usage
I have used [stow](https://www.gnu.org/software/stow/manual/stow.html) for managing the configurations seamlessly.
Stow creates symlinks to configurations from an arbitary locations stored as needed.
```bash
sudo apt install stow
```

```bash
sudo pacman -S stow
```

### Using Stow
Clone the repo and stow every directory in it. Eg:  
```bash
stow nvim
```
Creates symlinks for nvim configurations.

---

## i3
[https://github.com/NISH1001/paradox-configs/blob/master/my-i3.md](https://github.com/NISH1001/paradox-configs/blob/master/my-i3.md)

## neo-vim
[https://github.com/NISH1001/paradox-configs/blob/master/nvim/.config/nvim/README.md](https://github.com/NISH1001/paradox-configs/blob/master/nvim/.config/nvim/README.md)

## meta
[https://github.com/NISH1001/paradox-configs](https://github.com/NISH1001/paradox-configs)

## bash
**bashrc** and **inputrc** for bash stuff.

## claude

Claude Code user settings (`~/.claude/settings.json`) and the custom statusline script.

`stow claude` symlinks only those two files into `~/.claude/` — the rest of that directory
(history, projects, sessions, caches) is machine-local runtime state and stays out of git.

The statusline path in `settings.json` is written as `~/.claude/statusline-command.sh`
so it resolves on both macOS and Linux.

### Setting up on a new machine

```bash
mkdir -p ~/.claude
stow --no-folding -t ~ claude
```

The `mkdir` is **not optional**. If `~/.claude` doesn't exist yet, stow symlinks the whole
directory (`~/.claude -> paradox-configs/claude/.claude`) and Claude Code then writes its
history, sessions and caches straight into this repo. `--no-folding` guards the same case
on later re-stows.

If Claude Code already ran there, `~/.claude/settings.json` exists as a real file and stow
will refuse with a conflict — `mv ~/.claude/settings.json ~/.claude/settings.json.bak` first.

Claude Code rewrites `settings.json` itself when plugins are toggled or `/config` changes a
value. If that ever replaces the symlink with a regular file, re-link with `stow -R -t ~ claude`.

## mpv 
mpv configurations

## devilspie
control how windows appear

## greenclip

Clipboard manager: https://github.com/erebe/greenclip

We can just directly wget the binary and add to path

## cheat

Manage code snippet as cheatsheets.

## espanso

Text expander.

- Install [espanso](https://github.com/federico-terzi/espanso)
- Install [espanso-modulo](https://espanso.org/install/linux/#installing-modulo)

#### How to

- Get the binary from https://github.com/cheat/cheat/releases
- Put the binary into your path or user bin
- Get the community cheatsheets from https://github.com/cheat/cheatsheets into ~/.config/cheat/community folder

Note: I haven't added the community cheatsheets to git index of the paradox-config because this can easily be cloned.

`export CHEAT_CONFIG_PATH="~/.config/cheat/conf.yml"`

## PulseEffects

Limiter, compressor, convolver, equalizer and auto volume and many other plugins for PulseAudio/PipeWire applications.

https://github.com/wwmm/easyeffects

---

# TODO
- Automate download/configuration of important tools
