# zsh-only config, sourced after common.sh.

autoload -Uz compinit && compinit

# ignore casing
# Useful for cd, etc.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
