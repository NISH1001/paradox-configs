alias :q="exit"
alias vactive="source venv/bin/activate"
alias jn="jupyter  notebook --no-browse"

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

eval "$(jump shell)"

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
