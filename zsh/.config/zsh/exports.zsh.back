# fnm
eval "$(fnm env --use-on-cd --shell zsh)"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=$PATH:~/go/bin
export PATH=$PATH:$HOME/.local/bin

# zsh completions (brew) 
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
