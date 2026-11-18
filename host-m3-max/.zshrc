# ~/.zshrc for the M3 Max MacBook Pro (stow package: host-m3-max).
# Shared config lives in ~/.config/shell (stow package: shell). Anything that
# should apply on every machine belongs in common.sh, not here.

# Shared + OS config.
source ~/.config/shell/common.sh
source ~/.config/shell/zsh.zsh
[ -f ~/.config/shell/os-$(uname -s).sh ] && source ~/.config/shell/os-$(uname -s).sh

# ---------------------------------------------------------------------------
# Machine-specific below. Installers that edit ~/.zshrc append here.
# ---------------------------------------------------------------------------

alias puget1="npantha@puget1.nsstc.uah.edu"
alias dsig="npantha@dsig1.nsstc.uah.edu"
alias akd="cd ~/dev/impact/projects/accelerated-discovery"

alias abyss="llama-server \
    -hf ggml-org/Qwen2.5-Coder-1.5B-Q8_0-GGUF \
    --port 8012 -ngl 99 -fa -ub 1024 -b 1024 -dt 0.1 \
    --ctx-size 0 --cache-reuse 256"

# Hint to tools that respect $TERMINAL (some x-terminal-emulator wrappers,
# TUI apps, IDEs) that Ghostty is the preferred terminal on this machine.
# macOS has no real system-wide default-terminal setting; this is best-effort.
export TERMINAL=ghostty

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

# Added by Windsurf
export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
