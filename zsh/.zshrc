# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/dotfiles/zsh/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/dotfiles/zsh/.oh-my-zsh/custom"

export GO111MODULE=on
export GOPATH=$HOME/go
export GOROOT="/opt/homebrew/opt/go/libexec"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
export GOPRIVATE="bitbucket.org/pick-up"
# export TERM="xterm-256color"
export TERM="screen-256color"
export GST_PLUGIN_PATH=/usr/local/lib/gstreamer-1.0
# Add emacs into path
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/bin/lua:$PATH"
export PATH="/usr/local/bin/luarocks:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.config/emacs/bin:$PATH"
export GPG_TTY=$(tty)

# Re-enable this later
# export DEPLOY_KEY=$(cat ~/.ssh/id_rsa.base)
export POSTGRES_USER='pickupp'
export PATH=/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH

export INTEL_HAXM_HOME=/usr/local/Caskroom/intel-haxm

# Setting aliases for dev
alias gs='git status'
alias glog='git log --oneline --decorate --color --graph --all'
alias gl='git pull'
alias gp='git push'
alias gco="git checkout"
alias gb="git branch"

alias dk="docker-compose"
alias dkl='docker-compose logs --tail=1000 -f'
# alias gdiff="git log -m | ydiff -s -w 0 --wrap"
alias ref="source ~/.zshrc && echo refresh zshrc done"
# alias conflicts="nvim $(git diff --name-only --diff-filter=U)"
alias pml="pm2 logs --lines 100"
alias pmr="pm2 restart"
# alias pmstop="pm2 stop all && pm2 delete all && pm2 flush logs"
alias pms="pm2 stop all && pm2 flush logs && pm2 kill"

alias vimrc="nvim ~/.vimrc"
alias zshrc="nvim ~/.zshrc"
alias yabairc="nvim ~/.yabairc"
alias skhdrc="nvim ~/.skhdrc"
alias cl="clear"
alias pick="cd ~/go/src/bitbucket.org/pick-up/pickupp"

# Set name of the theme to load --- if set to "random"
# ZSH_THEME="spaceship"

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt appendhistory
# Setting up auto cd
set -o AUTO_CD

# Set word movement
bindkey "[D" backward-word
bindkey "[C" forward-word
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

plugins=(
  git
)

# source $ZSH/oh-my-zsh.sh
alias :q="exit"

alias portcheck="lsof -i"
alias scripts="cat package.json | jq -C .'scripts' | less -R"
alias rn="react-native"

alias filesize="du -hs "
alias agl='f() { ag -l $@ };f'
alias cleanbranches='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -d'
alias pstore='f() { psql -h localhost -p 5432 -d $1 -f $1.sql -U pickup };f'
alias localdump='f() { pg_dump -h localhost -p 5432 -U pickup $1 > $1.sql };f'
alias remotedump='f() { pg_dump -h $1 -U pickupp $2 > $2.sql };f'

alias clearcache='f() { rm -rf ~/Library/Developer/Xcode/Archives \
rm -rf ~/Library/Developer/Xcode/DerivedData \
rm -rf ~/Library/Developer/Xcode/iOS Device Logs/ \
rm -rf ~/Library/Caches/CocoaPods \
rm -rf ~/Library/Caches/com.apple.dt.Xcode/ \
};f'

alias ydiffs='f() { ydiff -s -w 0 --wrap };f'
alias evicclear='f() { kubectl get pod -n $1 | grep Evicted | awk "{print \$1}" | xargs kubectl delete pod -n $1 };f'
alias ls="gls --color"
# Export LS_COLORS according to tokyonight_moon theme
export LS_COLORS="$(vivid generate $HOME/dotfiles/vivid/tokyonight_moon.yml)"

function kill-node-port() {
  if [ -n "$1" ]; then
    lsof -i -P -n | grep LISTEN | grep "$@" | for i in `awk {'print$2'}`; do kill -9 $i; done
  else
    echo "Specify node port!"
  fi
}

alias pmkill='kill-node-port'

# Tre directory listing numerals
# tre() { command tre "$@" -e && source "/tmp/tre_aliases_$USER" 2>/dev/null;  }

export LC_ALL=en_US.UTF-8
# zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
# fpath=(~/.zsh $fpath)

export FZF_CTRL_R_OPTS='--border --info=inline'
export FZF_COMPLETION_TRIGGER='~~'

export FZF_DEFAULT_COMMAND='ag -g ""'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export EDITOR="/opt/homebrew/bin/nvim"
export DISABLE_AUTO_TITLE='true'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export SPACESHIP_NODE_SHOW=false
export SPACESHIP_PROMPT_ASYNC=false
export NEOVIDE_FRAME=none
# Disable homebrew auto update
export HOMEBREW_NO_AUTO_UPDATE=1
alias vibe="/Applications/Neovide.app/Contents/MacOS/neovide"
alias aerc="aerc --aerc-conf $HOME/.config/aerc/aerc.conf --accounts-conf $HOME/.config/aerc/accounts.conf --binds-conf $HOME/.config/aerc/binds.conf -a Personal"

typeset -U path cdpath fpath manpath

HISTFILE="$HOME/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
unsetopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY

. /opt/homebrew/opt/asdf/libexec/asdf.sh

# Expand aliases with space key
function expand-alias() {
	zle _expand_alias
	zle self-insert
}
zle -N expand-alias
bindkey -M main ' ' expand-alias

autoload -U select-word-style
select-word-style bash

# Tab completion highlight
autoload -U compinit
zstyle ':completion:*:*:*:*:*' menu select
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'
# zstyle ':completion:*:*:git:*' menu select list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fpath=(~/.zsh $fpath)
zmodload -i zsh/complist
setopt globdots
compinit

# .. expansion
function expand-dots() {
  local MATCH
  if [[ $LBUFFER =~ '(^| )\.\.\.+' ]]; then
    LBUFFER=$LBUFFER:fs%\.\.\.%../..%
  fi
}

function expand-dots-then-expand-or-complete() {
  zle expand-dots
  zle expand-or-complete
}

function expand-dots-then-accept-line() {
  zle expand-dots
  zle accept-line
}

zle -N expand-dots
zle -N expand-dots-then-expand-or-complete
zle -N expand-dots-then-accept-line
bindkey '^I' expand-dots-then-expand-or-complete
bindkey '^M' expand-dots-then-accept-line
bindkey '^[[Z' reverse-menu-complete

# MOAR config
export MOAR='--statusbar=bold --no-linenumbers'

# zsh-syntax-highligting & zsh-autosuggestions & spaceship theme
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/opt/spaceship/spaceship.zsh
