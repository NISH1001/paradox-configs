# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/bashrc.pre.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.pre.bash"
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
#HISTSIZE=1000
#HISTFILESIZE=2000
HISTSIZE=
HISTFILESIZE=

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#My custom scripts
export PATH=${PATH}:"~/Nish/Programming/bin/"


# Scala
export SCALA_HOME=/usr/local/src/scala/scala-2.11.7
export PATH=${PATH}:$SCALA_HOME/bin

export PATH=${PATH}:"/root/.gem/ruby/2.4.0/bin/"

export PATH=${PATH}:"~/.gem/ruby/2.4.0/bin/"

alias programming="cd ~/Nish/Programming"

#export XDG_CONFIG_HOME="$HOME/.config"

# color profile
#export PS1='\e[33;1m\u@\h: \e[31m\W\e[0m\$ '
export PS1='[\[\033[33;1m\]\u@\h]\[\033[00m\]:\[\033[01;35m\]\W\[\033[00m\]\$ '

# green color + underline for folders
# turquoise color + normal for files
# light red + bold for pdf
LS_COLORS=$LS_COLORS:'di=4;37:fi=0;96:*.pdf=1;91:' ; export LS_COLORS

#alias vim="nvim"
alias termup="xrdb ~/.Xresources"

export EDITOR=nvim
export VISUAL=nvim

#set completion-ignore-case on
alias dict="sdcv"
alias octave="octave-cli"

alias sync_me="sudo pacman -Syu"
alias sync_packages="sudo pacman -Syy"

alias :q="exit"
alias rip="shutdown now"
alias takeanap="sudo systemctl suspend"
alias vim="nvim"
#alias myip="echo $(dig +short myip.opendns.com @resolver1.opendns.com)"


shopt -s autocd
shopt -s checkwinsize


#export WORKON_HOME=$HOME/.virtualenvs
#export PROJECT_HOME=$HOME/Nish/Programming/Python/Virtualenv
#source /usr/bin/virtualenvwrapper.sh

export WINPREFIX=$HOME/.config/wine/
export WINEARCH=win64

export FZF_DEFAULT_OPTS='--height 100% '

#export JAVA_TOOL_OPTIONS=-Dfuseprospector.env=local
#export JAVA_TOOL_OPTIONS=-D--spring.config.location=src/main/resources/application-local.properties
#export JAVA_TOOL_OPTIONS=-D--spring.config.location=/home/paradox/eclipse-workspaces/fusemachines/fusesalesapp/src/main/resources/application-local.properties

#export JAVA_TOOL_OPTIONS=-Dspring.config.location=classpath:application-local.properties

# ----------- crazy functions ----------
#functions for going up a certain number of directories and back
function up( )
{
    LIMIT=$1
    P=$PWD
    for ((i=1; i <= LIMIT; i++))
    do
        P=$P/..
    done
    cd $P
    export MPWD=$P
}

function back( )
{
    LIMIT=$1
    P=$MPWD
    for ((i=1; i <= LIMIT; i++))
    do
        P=${P%/..}
    done
    cd $P
    export MPWD=$P
}

function pipgrep(  )
{

    if [ -z "$1" ]
    then
        val=$(pip freeze)
    else
        val=$(pip freeze | grep -i $1)
    fi

    echo -e "$val"
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

source ~/.local/share/icons-in-terminal/icons_bash.sh

# eval $(thefuck --alias)
# eval $(thefuck --alias --enable-experimental-instant-mode)

# added by Anaconda3 installer
#export PATH="/home/paradox/anaconda3/bin:$PATH"

# source ~/.secrets

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# write history to the file
# export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.bash-logs/logs/bash-history-$(date "+%Y-%m-%d").log; fi'

# alias
alias :q="exit"
#alias python="python3"
alias scmd="~/bin/scmd.py"
alias vactive="source venv/bin/activate"
alias jn="jupyter  notebook --no-browse"

# ---


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/nishparadox/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/nishparadox/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/nishparadox/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/nishparadox/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"
export PATH="$PYENV_ROOT/bin:$PATH"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
#if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

[[ -s /home/nishparadox/.autojump/etc/profile.d/autojump.sh ]] && source /home/nishparadox/.autojump/etc/profile.d/autojump.sh

. "$HOME/.cargo/env"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/bashrc.post.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.post.bash"
