# ~/.zshrc for the M4 MacBook Air (stow package: host-m4-air).
# Shared config lives in ~/.config/shell (stow package: shell). Anything that
# should apply on every machine belongs in common.sh, not here.

# Shared + OS config.
source ~/.config/shell/common.sh
source ~/.config/shell/zsh.zsh
[ -f ~/.config/shell/os-$(uname -s).sh ] && source ~/.config/shell/os-$(uname -s).sh

# ---------------------------------------------------------------------------
# Machine-specific below. Installers that edit ~/.zshrc append here.
# ---------------------------------------------------------------------------

alias abyss="llama-server \
    -hf ggml-org/Qwen2.5-Coder-1.5B-Q8_0-GGUF \
    --port 8012 -ngl 99 -fa -ub 1024 -b 1024 -dt 0.1 \
    --ctx-size 0 --cache-reuse 256"
