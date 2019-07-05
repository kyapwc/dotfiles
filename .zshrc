# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/kenyap/.oh-my-zsh"
export GO111MODULE=off
export GOPATH=$HOME/go
export GOROOT="/usr/local/opt/go/libexec"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
export DEPLOY_KEY=$(cat ~/.ssh/id_rsa.base)
export RIPGREP_CONFIG_PATH='/Users/kenyap/.ripgreprc'
export POSTGRES_USER='pickup'
export PATH="$HOME/.npm-packages/bin:$PATH"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_192.jdk/Contents/Home/"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export NVM_DIR="$HOME/.custom-nvm"
export NVM_LAZY_LOAD=true
export PATH="$PATH:$HOME/.custom-nvm/versions/node/v8.15.0/bin"
export PATH="$PATH:$HOME/workspace/flutter/bin"
export PATH="$PATH:$HOME/.pub-cache/bin"
# source /usr/local/opt/nvm/nvm.sh
# Load rupa's z if installed
[ -f /usr/local/etc/profile.d/z.sh  ] && source /usr/local/etc/profile.d/z.sh

# Setting aliases for dev
alias code='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'
alias gs='git status'
alias glog='git log --oneline --decorate --color --graph --all'
alias dk="docker-compose"
alias dks="docker-compose -f docker-compose-shopify.yml"
alias dksl="docker-compose -f docker-compose-shopify.yml logs -f"
alias dksr="docker-compose -f docker-compose-shopify.yml restart"
alias dkl='docker-compose logs --tail=1000 -f'
alias dkr="docker-compose restart"
alias gco="git checkout"
alias gb="git branch"
# alias gdiff="git log -m | ydiff -s -w 0 --wrap"
alias gdiff="git diff | ydiff -s"
alias ref="quote qotd && source ~/.zshrc && echo refresh zshrc done"
alias mpv="open -na /Applications/mpv.app"
alias conflicts="vim $(git diff --name-only --diff-filter=U)"

# Task warrior alias
alias tka="task all"
alias tkl="task list"
alias ta="task add"
alias calc="task calc"
alias tki="task information"

# cd into pickupp dir
alias pickorder="cd $HOME/go/src/bitbucket.org/pick-up/orderservice/"
alias pickgateway="cd $HOME/go/src/bitbucket.org/pick-up/gateway/"
alias pickuserapp="cd $HOME/go/src/bitbucket.org/pick-up/pickuppuserapp/"
alias pickmerchant="cd $HOME/go/src/bitbucket.org/pick-up/merchant-portal/"
alias pickadmin="cd $HOME/go/src/bitbucket.org/pick-up/admin-portal/"

alias vimrc="vim ~/.vimrc"
alias zshrc="vim ~/.zshrc"
alias chunk="vim ~/.chunkwmrc"
alias skhdrc="vim ~/.skhdrc"
alias ncmp="ncmpcpp"
alias ideac="idea create "
alias ideav="idea view"
alias ideas="idea list"
alias cl="clear"

# Vim start session
alias vims="vim -S ~/.vim/vim-session.vim"
# Set name of the theme to load --- if set to "random"
ZSH_THEME="spaceship"

HISTSIZE=1000
SAVEHIST=1000

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
  zsh-nvm
  zsh-autosuggestions
  zsh-syntax-highlighting
  k
)

source $ZSH/oh-my-zsh.sh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship

# Set kitty completion on zsh
# autoload -Uz compinit
# compinit
# kitty + complete setup zsh | source /dev/stdin

# PM functions
# source ~/.pm/pm.zsh
# alias pma="pm add"
# alias pmg="pm go"
# alias pmrm="pm remove"
# alias pml="pm list"
# end PM
# LazyGit
alias lg="lazygit"
# Unalias GRV
# unalias grv
# GITA
alias gita="python3 -m gita"
alias :q="exit"
alias dkstart="dk up -d address admin agent geo postgres redis order rating notification cronjob geo wallet payroll warehouse merchant gateway"

# Annihilate all containers in docker
alias dockannihilate="docker kill $(docker ps -q) && docker rm $(docker ps -a -q)"
# alias tnew="tmux new -s "
# alias tatt="tmux attach -t "
# alias tls="tmux ls"
# alias tkill="tmux kill-session -t "
# alias tkillall="tmux ls | grep : | cut -d. -f1 | awk '{print substr($1, 0, length($1)-1)}' | xargs kill"
alias portcheck="lsof -i"
# alias rgl="f() { rg --pretty %s | less  };f"
# alias rgv="f() { vim $(rg --files-with-matches $@)  };f"
alias bump="vim package.json package-lock.json"
alias scripts="cat package.json | jq -C .'scripts' | less -R"
alias rn="react-native"
# alias killandroid="sudo killall -9 $(ps aux | grep -i Best_Testing_Device | awk 'NR==1{print $11}' | xargs basename)"
alias filesize="du -hs "
alias dockprune="docker image prune -a"
alias genMigration='f() { DATABASE_URL=postgresql://pickup@localhost/$1 ./node_modules/.bin/sequelize migration:generate --name $2 };f'
alias migrateUp='f() { DATABASE_URL=postgresql://pickup@localhost/$1 ./node_modules/.bin/sequelize db:migrate };f'
alias migrateDown='f() { DATABASE_URL=postgresql://pickup@localhost/$1 ./node_modules/.bin/sequelize db:migrate:undo };f'
alias agl='f() { ag -l $@ };f'
alias gsd='git diff --cached'
alias cleanbranches='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -d'
export LC_ALL=en_US.UTF-8
