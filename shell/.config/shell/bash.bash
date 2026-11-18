# bash-only config, sourced after common.sh.

# don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
# unlimited history
HISTSIZE=
HISTFILESIZE=

# update LINES and COLUMNS after each command
shopt -s checkwinsize
# cd by typing a directory name (bash 4+; silently skipped on macOS bash 3.2)
shopt -s autocd 2>/dev/null

export PS1='[\[\033[33;1m\]\u@\h]\[\033[00m\]:\[\033[01;35m\]\W\[\033[00m\]\$ '

export EDITOR=nvim
export VISUAL=nvim
export FZF_DEFAULT_OPTS='--height 100% '

# programmable completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
