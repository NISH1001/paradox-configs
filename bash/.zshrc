# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
eval $(/opt/homebrew/bin/brew shellenv)

source $HOME/.zshfuncs

alias :q="exit"
alias vactive="source venv/bin/activate"
alias jn="jupyter  notebook --no-browse"

export PATH="$PATH:/Users/nishparadox/Library/Python/3.8/bin"
export PATH="$PATH:$HOME/bin"

export PYENV_ROOT="$HOME/.pyenv" 
export PATH="$PYENV_ROOT/bin:$PATH" 
eval "$(pyenv init --path)" 
eval "$(pyenv init -)"

# custom bash log
export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.bash-logs/logs/bash-history-$(date "+%Y-%m-%d").log; fi'
prmptcmd() { eval "$PROMPT_COMMAND" }
precmd_functions=(prmptcmd)

[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

autoload -Uz compinit && compinit
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/nishparadox/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/nishparadox/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/nishparadox/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/nishparadox/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
