# ── yazi — выход в текущую папку ─────────────────────────────────────────────
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ── pwgen — генератор паролей ─────────────────────────────────────────────────
pwgen() {
  local len=${1:-20}
  LC_ALL=C tr -dc 'A-Za-z0-9@#%^&*()_+=-{}[]:;<>,.?/' < /dev/urandom | head -c "$len" | xargs echo
}
