export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

[ -f "/Users/simonlie/.ghcup/env" ] && source "/Users/simonlie/.ghcup/env" # ghcup-env
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
path+=('/Users/simonlie/go/bin')
# . "/Users/simonlie/.deno/env"export PATH="/opt/homebrew/opt/binutils/bin:$PATH"

PROMPT='%B%F{27}%1~%f%b %# '
setopt HIST_IGNORE_ALL_DUPS   # Removes older duplicate entries from history
setopt HIST_IGNORE_SPACE      # Ignores commands that start with a space

alias ls='ls -G'   # Add color to ls
alias ll='ls -l'
alias la='ls -A'

alias g='git'
alias ga='git add'
alias gcm='git commit -m'
alias gf='git fetch'
alias gl='git pull'
alias gp='git push'

alias e='exit'
