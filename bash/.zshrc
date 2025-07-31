alias :q="exit"
#alias vactive="source venv/bin/activate"
alias vactive='if [ -d "venv" ]; then source venv/bin/activate; elif [ -d ".venv" ]; then source .venv/bin/activate; else echo "No virtual environment found"; fi'

alias jn="jupyter  notebook --no-browse"
alias jl="jupyter  lab --no-browse"
alias puget1="npantha@puget1.nsstc.uah.edu"
alias dsig="npantha@dsig1.nsstc.uah.edu"

autoload -Uz compinit && compinit

# ignore casing 
# Useful for cd, etc.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/npantha/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/npantha/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/npantha/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/npantha/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)" 
eval "$(pyenv init -)"


# navigate to previous directory
up() {
    LIMIT=${1:-1}
    P=$PWD
    for ((i=1; i <= LIMIT; i++)); do
        P=$P/..
    done
    cd "$P"
    export MPWD=$P
}

# easily grep
pipgrep() {

    if [ -z "$1" ]
    then
        val=$(pip freeze)
    else
        val=$(pip freeze | grep -i $1)
    fi

    echo -e "$val"
}
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh


# JINA_CLI_BEGIN

## autocomplete
if [[ ! -o interactive ]]; then
    return
fi

compctl -K _jina jina

_jina() {
  local words completions
  read -cA words

  if [ "${#words}" -eq 2 ]; then
    completions="$(jina commands)"
  else
    completions="$(jina completions ${words[2,-2]})"
  fi

  reply=(${(ps:
:)completions})
}

# session-wise fix
ulimit -n 4096
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# JINA_CLI_END

export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
# source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
# source /opt/homebrew/opt/chruby/share/chruby/auto.sh
# chruby ruby-3.3.0 # run chruby to see actual version

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

. "$HOME/.cargo/env"

# Added by Windsurf
export PATH="/Users/npantha/.codeium/windsurf/bin:$PATH"

alias abyss="llama-server \
    -hf ggml-org/Qwen2.5-Coder-1.5B-Q8_0-GGUF \
    --port 8012 -ngl 99 -fa -ub 1024 -b 1024 -dt 0.1 \
    --ctx-size 0 --cache-reuse 256"

alias lah="ls -lah"
alias duh="du -sh ."



export PATH="/Users/npantha/bin:$PATH"
