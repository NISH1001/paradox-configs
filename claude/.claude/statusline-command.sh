#!/bin/sh
# Claude Code statusLine — dir | branch | model | context window usage | cost
# Reads the session JSON from stdin (see `code.claude.com/docs/en/statusline`).

input="$(cat)"

# --- ANSI colors ---
RESET='\033[0m'; DIM='\033[2m'
YELLOW='\033[33m'; MAGENTA='\033[35m'; CYAN='\033[36m'
GREEN='\033[32m'; RED='\033[31m'; BOLD='\033[1m'

# --- pull fields (defensive: tolerate missing/null) ---
dir="$(printf '%s' "$input"   | jq -r '.workspace.current_dir // .cwd // ""')"
model="$(printf '%s' "$input" | jq -r '.model.display_name // .model.id // "?"')"
cost="$(printf '%s' "$input"  | jq -r '.cost.total_cost_usd // 0')"

used="$(printf '%s' "$input"  | jq -r '.context_window.total_input_tokens // empty')"
cap="$(printf '%s' "$input"   | jq -r '.context_window.context_window_size // empty')"
pct="$(printf '%s' "$input"   | jq -r '.context_window.used_percentage // empty')"

# basename of the working dir
base="$(basename "${dir:-$PWD}")"

# git branch (only if inside a repo)
branch=""
if git -C "${dir:-$PWD}" rev-parse --git-dir >/dev/null 2>&1; then
  branch="$(git -C "${dir:-$PWD}" branch --show-current 2>/dev/null)"
fi

# --- humanize a token count: 1500 -> 1.5k, 1000000 -> 1M ---
human() {
  awk -v n="$1" 'BEGIN{
    if (n=="" || n==0) { print "0"; exit }
    if (n>=1000000) { v=n/1000000; printf (v==int(v)?"%dM":"%.1fM"), v }
    else if (n>=1000) { printf "%dk", int(n/1000+0.5) }
    else { printf "%d", n }
  }'
}

# --- assemble ---
out="$(printf '%b%s%b' "$MAGENTA$BOLD" "$base" "$RESET")"

[ -n "$branch" ] && out="$out $(printf '%b%s%b' "$DIM" "⎇ $branch" "$RESET")"

out="$out $(printf '%b%s%b' "$CYAN" "[$model]" "$RESET")"

# context window gauge: ctx 120k/1M 12%  (color shifts as it fills)
if [ -n "$used" ] && [ -n "$cap" ]; then
  p="${pct%.*}"; [ -z "$p" ] && p=0
  if [ "$p" -ge 85 ]; then ctxcol="$RED"
  elif [ "$p" -ge 60 ]; then ctxcol="$YELLOW"
  else ctxcol="$GREEN"; fi
  gauge="ctx $(human "$used")/$(human "$cap") ${p}%"
  out="$out $(printf '%b%s%b' "$ctxcol" "$gauge" "$RESET")"
fi

# session cost (only when nonzero)
nonzero="$(awk -v c="$cost" 'BEGIN{print (c+0>0)?"1":"0"}')"
[ "$nonzero" = "1" ] && out="$out $(printf '%b$%.2f%b' "$DIM" "$cost" "$RESET")"

printf '%b' "$out"
