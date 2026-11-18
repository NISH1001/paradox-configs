# Shared shell config, sourced by both bash and zsh on every machine
# (see host-<machine>/.zshrc and host-<machine>/.bashrc).
#
# Keep this file shell-neutral: it must run in zsh and in bash 3.2 (macOS).
# Only put things here that should apply everywhere. Tool setup is guarded so
# it is a no-op on machines where the tool is not installed.

alias :q="exit"
alias vactive='if [ -d "venv" ]; then source venv/bin/activate; elif [ -d ".venv" ]; then source .venv/bin/activate; else echo "No virtual environment found"; fi'

alias jn="jupyter  notebook --no-browse"
alias jl="jupyter  lab --no-browse"
alias duh="du -sh ."
alias envrc="source .envrc"
command -v nvim >/dev/null 2>&1 && alias vim="nvim"

if command -v eza >/dev/null 2>&1; then
    alias ls="eza"
    alias lah="eza --long"
    alias l='eza -lh'           # long format
    alias ll='eza -lah'         # long format with hidden files
    alias la='eza -a'           # all files
    alias lt='eza --tree'       # tree view
    alias lg='eza -lah --git'   # long format with git status
else
    alias lah="ls -lah"
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[ -d "$PYENV_ROOT/bin" ] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null 2>&1; then
    # `init -` already sets up PATH, so a separate `init --path` is redundant.
    # --no-rehash skips rebuilding every shim on each shell start (~175 ms);
    # run `pyenv rehash` by hand if a newly installed command is not found.
    eval "$(pyenv init - --no-rehash)"
fi

# rbenv
[ -d "$HOME/.rbenv/bin" ] && export PATH="$HOME/.rbenv/bin:$PATH"
[ -d "$HOME/.rbenv/shims" ] && export PATH="$HOME/.rbenv/shims:$PATH"

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# go up N directories (default 1); `back` undoes it
up() {
    LIMIT=${1:-1}
    P=$PWD
    for ((i=1; i <= LIMIT; i++)); do
        P=$P/..
    done
    cd "$P"
    export MPWD=$P
}

back() {
    LIMIT=${1:-1}
    P=$MPWD
    for ((i=1; i <= LIMIT; i++)); do
        P=${P%/..}
    done
    cd "$P"
    export MPWD=$P
}

# easily grep installed pip packages
pipgrep() {
    if [ -z "$1" ]; then
        val=$(pip freeze)
    else
        val=$(pip freeze | grep -i "$1")
    fi
    echo -e "$val"
}
