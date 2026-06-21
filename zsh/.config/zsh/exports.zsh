# === PATH (cross-platform clean way) ===
typeset -U path

# user local binaries (pip, uv, cargo, etc)
path=(
  "$HOME/.local/bin"
  "$HOME/go/bin"
  $path
)

# Linux-specific (Fedora)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if [[ -d "$HOME/.local/share/fnm" ]]; then
    path=("$HOME/.local/share/fnm" $path)
  fi
fi

# macOS Homebrew (Apple Silicon + Intel)
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# zsh completions (brew)
if command -v brew &>/dev/null; then
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi

# fnm (ONLY AFTER PATH IS READY)
if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi
