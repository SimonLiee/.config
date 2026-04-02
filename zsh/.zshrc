export XDG_CONFIG_HOME="$HOME/.config"

path=(
  /opt/homebrew/opt/openjdk/bin
  $HOME/.yarn/bin
  $HOME/.config/yarn/global/node_modules/.bin
  $HOME/go/bin
  $path
)
export PATH

PROMPT='%B%F{27}%1~%f%b %# '

setopt HIST_IGNORE_ALL_DUPS   # Removes older duplicate entries from history
setopt HIST_IGNORE_SPACE      # Ignores commands that start with a space

# Enable autocomplete
autoload -Uz compinit && compinit

alias ls='ls -G'   # Add color to ls
alias ll='ls -l'
alias la='ls -A'

alias ga='git add'
alias gc='git commit -m'
alias gf='git fetch'
alias gpl='git pull'
alias gp='git push'

alias e='exit'

function preexec() {
  [[ -n "$TMUX" ]] || return
  local cmd=${1%% *}
  [[ "$cmd" == "$LAST_TMUX_CMD" ]] && return
  LAST_TMUX_CMD="$cmd"
  tmux rename-window "$cmd"
}

source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
ZVM_VI_SURROUND_BINDKEY=s-prefix
