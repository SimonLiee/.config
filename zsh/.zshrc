export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
path+=('/Users/simonlie/go/bin')

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
alias gpl='git pull'
alias gp='git push'

alias e='exit'
