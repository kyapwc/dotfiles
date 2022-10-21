# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/kenyap/.oh-my-zsh"
export GO111MODULE=on
export GOPATH=$HOME/go
export GOROOT="/usr/local/opt/go/libexec"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
export GOPRIVATE="bitbucket.org/pick-up"
export TESSDATA_PREFIX="/usr/local/share/tessdata/"
export TERM="xterm-256color-italic"
export GST_PLUGIN_PATH=/usr/local/lib/gstreamer-1.0

# Flutter
# export PATH="$PATH:/Users/kenyap/flutter/bin"

export DEPLOY_KEY=$(cat ~/.ssh/id_rsa.base)
export POSTGRES_USER='pickup'
export PATH=/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH

export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH="/usr/local/Cellar/openvpn/2.5.7/sbin:$PATH"

# Setting aliases for dev
alias gs='git status'
alias glog='git log --oneline --decorate --color --graph --all'
alias dk="docker-compose"
alias dkl='docker-compose logs --tail=1000 -f'
alias gco="git checkout"
alias gb="git branch"
# alias gdiff="git log -m | ydiff -s -w 0 --wrap"
alias ref="source ~/.zshrc && echo refresh zshrc done"
# alias conflicts="nvim $(git diff --name-only --diff-filter=U)"
alias pml="pm2 logs --lines 100"
alias pmr="pm2 restart"
alias pms="pm2 start"
alias pmstop="pm2 stop all && pm2 delete all && pm2 flush logs"

alias vimrc="nvim ~/.vimrc"
alias zshrc="nvim ~/.zshrc"
alias yabairc="nvim ~/.yabairc"
alias skhdrc="nvim ~/.skhdrc"
alias cl="clear"
alias work="cd ~/go/src/bitbucket.org/pick-up"
alias pick="cd ~/go/src/bitbucket.org/pick-up/pickupp"

# alias vr="nvim `git show --pretty='' --name-only`"

# nvim start session
alias vims="vim -S ~/.vim/vim-session.vim"
alias nvims="nvim -S ~/.config/nvim/vim-session.nvim"
# Set name of the theme to load --- if set to "random"
ZSH_THEME="spaceship"

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt appendhistory

# Set word movement
bindkey "[D" backward-word
bindkey "[C" forward-word

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  docker-compose
  zsh-nvm
)
export NVM_LAZY_LOAD=true

source $ZSH/oh-my-zsh.sh

# GITA
alias gita="python3 -m gita"
alias :q="exit"

alias portcheck="lsof -i"
alias bump="nvim package.json package-lock.json"
alias scripts="cat package.json | jq -C .'scripts' | less -R"
alias rn="react-native"

alias filesize="du -hs "
alias dockprune="docker image prune -a"
alias agl='f() { ag -l $@ };f'
alias cleanbranches='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -d'
alias pstore='f() { psql -h localhost -p 5432 -d $1 -f $1.sql -U pickup };f'
alias localdump='f() { pg_dump -h localhost -p 5432 -U pickup $1 > $1.sql };f'
alias remotedump='f() { pg_dump -h $1 -U pickupp $2 > $2.sql };f'
alias vag='f() { nvim $(ag -l $@) };f'

alias ver="cat package.json | jq .version"
alias gti="f() { git update-index --assume-unchanged $@ };f"
alias gtic="f() { git update-index --no-assume-unchanged $@ };f"

alias nme='f() { osascript -e "display notification \"$1\" with title \"$2\" sound name \"Hero\"" };f'

alias clearcache='f() { rm -rf ~/Library/Developer/Xcode/Archives \
rm -rf ~/Library/Developer/Xcode/DerivedData \
rm -rf ~/Library/Developer/Xcode/iOS Device Logs/ \
rm -rf ~/Library/Caches/CocoaPods \
rm -rf ~/Library/Caches/com.apple.dt.Xcode/ \
};f'

alias tms='f() { tmuxp load $1 };f'

alias boilr="~/bin/boilr"

function kill-node-port() {
  if [ -n "$1" ]; then
    lsof -i -P -n | grep LISTEN | grep "$@" | for i in `awk {'print$2'}`; do kill -9 $i; done
  else
    echo "Specify node port!"
  fi
}

alias pmkill='kill-node-port'

alias migrateUp='f() { DATABASE_URL=postgresql://postgres@localhost/$1 ./node_modules/.bin/sequelize migration:generate --name $2 };f'
alias migrateDown='f() { DATABASE_URL=postgresql://postgres@localhost/$1 ./node_modules/.bin/sequelize db:migrate:undo };f'

# Tre directory listing numerals
# tre() { command tre "$@" -e && source "/tmp/tre_aliases_$USER" 2>/dev/null;  }

export LC_ALL=en_US.UTF-8

autoload -Uz compinit && compinit
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
  compinit
else
  compinit -C
fi

export KITTY_CONFIG_DIRECTORY="~/.config/kitty/kitty.conf"

# NVM stuff
# export NVM_DIR=~/.nvm
# source /usr/local/opt/nvm/nvm.sh
# source ~/.zsh_npm
export BITBUCKET_APP_PASSWORD=Kv7ChvThwqQA3Z8wBdFT
export BITBUCKET_USERNAME=kyapweichun
export FZF_CTRL_R_OPTS='--border --info=inline'
export FZF_COMPLETION_TRIGGER='~~'

export FZF_DEFAULT_COMMAND='ag -g ""'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export EDITOR="/usr/local/bin/nvim"
export DISABLE_AUTO_TITLE='true'

# bun completions
[ -s "/Users/kenyap/.bun/_bun" ] && source "/Users/kenyap/.bun/_bun"

# Bun
export BUN_INSTALL="/Users/kenyap/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

