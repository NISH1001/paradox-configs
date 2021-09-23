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

---

# TODO
- Automate download/configuration of important tools
