# ~/.bashrc for the M3 Max MacBook Pro (stow package: host-m3-max).
# Shared config lives in ~/.config/shell (stow package: shell). Anything that
# should apply on every machine belongs in common.sh, not here.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

source ~/.config/shell/common.sh
source ~/.config/shell/bash.bash
[ -f ~/.config/shell/os-$(uname -s).sh ] && source ~/.config/shell/os-$(uname -s).sh

# ---------------------------------------------------------------------------
# Machine-specific below. Installers that edit ~/.bashrc append here.
# ---------------------------------------------------------------------------

alias akd="cd ~/dev/impact/projects/accelerated-discovery"

alias abyss="llama-server \
    -hf ggml-org/Qwen2.5-Coder-1.5B-Q8_0-GGUF \
    --port 8012 -ngl 99 -fa -ub 1024 -b 1024 -dt 0.1 \
    --ctx-size 0 --cache-reuse 256"

# JINA_CLI_BEGIN

## autocomplete
_jina() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(jina commands)" -- "$word") )
  else
    local words=("${COMP_WORDS[@]}")
    unset words[0]
    unset words[$COMP_CWORD]
    local completions=$(jina completions "${words[@]}")
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -F _jina jina

# session-wise fix
ulimit -n 4096
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# JINA_CLI_END
