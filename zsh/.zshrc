# zmodload zsh/zprof
FPATH="$HOME/.zfunc:${FPATH}"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
OS=$(uname)

# Path to your oh-my-zsh installation.
export ZSH="$HOME/dotfiles/zsh/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/dotfiles/zsh/.oh-my-zsh/custom"

export GO111MODULE=on
export GOPATH=$HOME/go
if [[ $OS == "Linux" ]]; then
  export GOROOT="/bin/go"
else
  export GOROOT="/opt/homebrew/opt/go/libexec"
fi

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
export PATH="$HOME/.local/share/mise/shims:$PATH"
export GPG_TTY=$(tty)
export TERMINFO=/usr/share/terminfo

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
alias lg="lazygit"

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
alias work="cd ~/respond.io/"

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
# alias ls="gls --color"
alias ls="eza"
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
if [[ $OS == "Linux" ]]; then
  source <(fzf --zsh)
  . /opt/asdf-vm/asdf.sh
  export EDITOR="/usr/bin/nvim"
else
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  alias vibe="/Applications/Neovide.app/Contents/MacOS/neovide"
  export EDITOR="/opt/homebrew/bin/nvim"
fi

export DISABLE_AUTO_TITLE='true'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export SPACESHIP_NODE_SHOW=false
export SPACESHIP_PROMPT_ASYNC=false
export NEOVIDE_FRAME=none
# Disable homebrew auto update
export HOMEBREW_NO_AUTO_UPDATE=1
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
function replace_multiple_dots() {
  local dots=$LBUFFER[-3,-1]
  if [[ $dots =~ "^[ //\"']?\.\.$" ]]; then
    LBUFFER=$LBUFFER[1,-3]'../.'
  fi
  zle self-insert
}

function expand-dots-then-expand-or-complete() {
  zle expand-or-complete
}

function expand-dots-then-accept-line() {
  zle accept-line
}

function find_and_upgrade_package() {
	find ./* -name "package.json" | xargs grep -l "\"$1\": \"*\"" | xargs -I {} bash -c "npm --prefix \$(dirname {}) install --no-audit --save-exact $1@$2 &" | >/dev/null
}

function respond_reinstall_packages() {
  echo "=================================================================="
  echo "Reinstalling packages..."

  git diff --name-only | xargs -I {} dirname {} | uniq | while read dir; do
    echo "Checking directory: $dir"
    if [ -d "$dir" ]; then
      echo "Directory exists."
      echo "$dir/package.json check..."
      if [ -f "$dir/package.json" ]; then
        echo "package.json exists. Running npm install."
        (cd "$dir" && npm install)
      else
        echo "package.json does not exist."
      fi
    else
      echo "Directory does not exist."
    fi
  done

  echo "Done reinstalling packages..."
  echo "=================================================================="
}

# Function to run a package script
run_node_package_script() {
  [[ -f package.json ]] || { echo "No package.json found"; return 1 }

  local selected
  selected=$(jq -r '.scripts | to_entries[] | "\(.key)\t\(.value)"' package.json | \
    fzf --with-nth=1 \
        --delimiter='\t' \
        --prompt="Select npm script: " \
        --preview='printf "%s" "{}" | cut -f2- | bat --style=plain --language=sh --color=always' \
        --preview-window=up:3:wrap | sed "s/'//g")

  script_name="${selected%%$'\t'*}"
  script_cmd="${selected#*$'\t'}"

  if [[ -n "$script_name" ]]; then
    echo "Running: npm run $script_name"
    npm run "$script_name"
    zle reset-prompt  # Only reset the prompt after running the script
  fi
}
run-package-script-widget() {
  if [[ -f package.json ]]; then
    zle -I
    run_node_package_script
  else
    echo "No package.json found, no script to run."
    zle send-break
  fi
}
zle -N run-package-script-widget

stty -ixon
bindkey '^S' run-package-script-widget

zle -N replace_multiple_dots
zle -N expand-dots-then-expand-or-complete
zle -N expand-dots-then-accept-line
bindkey '.' replace_multiple_dots
bindkey '^I' expand-dots-then-expand-or-complete
bindkey '^M' expand-dots-then-accept-line
bindkey '^[[Z' reverse-menu-complete

if [[ $OS == "Linux" ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source /usr/lib/spaceship-prompt/spaceship.zsh
else
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source /opt/homebrew/opt/spaceship/spaceship.zsh
  fpath=(/opt/homebrew/share/zsh-completions $fpath)
fi

source $HOME/dotfiles/zsh/completion.zsh

# zsh-syntax-highligting & zsh-autosuggestions & spaceship theme
# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /usr/lib/spaceship-prompt/spaceship.zsh

# zprof
