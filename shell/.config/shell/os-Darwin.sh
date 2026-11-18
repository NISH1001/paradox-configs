# macOS-only config (Homebrew locations etc.), sourced by both bash and zsh.

[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
[ -d /opt/homebrew/opt/postgresql@15/bin ] && export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
