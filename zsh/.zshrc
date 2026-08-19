# zmodload zsh/zprof
FPATH="$HOME/.zfunc:${FPATH}"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
OS=$(uname)

# Path to your oh-my-zsh installation.
export ZSH="$HOME/dotfiles/zsh/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/dotfiles/zsh/.oh-my-zsh/custom"

export GO111MODULE=on
if [[ $OS == "Linux" ]]; then
  export GOROOT="/bin/go"
# else
#   export GOROOT="/opt/homebrew/opt/go/libexec"
fi

# GOPATH for installed binaries and caches
export GOPATH="$HOME/go"
export GOTOOLCHAIN=local

# PATH so "go install" binaries are available
export PATH="$GOPATH/bin:/opt/homebrew/bin:$PATH"
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
# export GS4JS_HOME="/usr/local/lib"
# `mise activate zsh` just prints a static block of shell functions/hooks
# that only changes when the `mise` binary itself is upgraded -- spawning it
# on every shell startup costs ~30-40ms for no reason. Cache its output and
# regenerate only when the binary is newer than the cache.
MISE_ACTIVATE_CACHE="$HOME/.cache/mise/activate-zsh.zsh"
MISE_BIN="$(command -v mise)"
if [[ -n "$MISE_BIN" ]]; then
  if [[ ! -s "$MISE_ACTIVATE_CACHE" || "$MISE_BIN" -nt "$MISE_ACTIVATE_CACHE" ]]; then
    mkdir -p "$(dirname "$MISE_ACTIVATE_CACHE")"
    mise activate zsh > "$MISE_ACTIVATE_CACHE"
  fi
  source "$MISE_ACTIVATE_CACHE"
fi
unset MISE_BIN

# Re-enable this later
# export DEPLOY_KEY=$(cat ~/.ssh/id_rsa.base)
export POSTGRES_USER='pickupp'
export PATH=/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH

export INTEL_HAXM_HOME=/usr/local/Caskroom/intel-haxm

# Setting aliases for dev
# alias gs='git status'
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
# `vivid generate` output is fully determined by that yml file, so cache it
# instead of spawning vivid on every shell startup; regenerate only when the
# theme file is newer than the cache.
VIVID_THEME="$HOME/dotfiles/vivid/tokyonight_moon.yml"
VIVID_LSCOLORS_CACHE="$HOME/.cache/vivid/lscolors-tokyonight_moon"
if [[ ! -s "$VIVID_LSCOLORS_CACHE" || "$VIVID_THEME" -nt "$VIVID_LSCOLORS_CACHE" ]]; then
  mkdir -p "$(dirname "$VIVID_LSCOLORS_CACHE")"
  vivid generate "$VIVID_THEME" > "$VIVID_LSCOLORS_CACHE"
fi
export LS_COLORS="$(<"$VIVID_LSCOLORS_CACHE")"
unset VIVID_THEME

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
export SPACESHIP_PROMPT_ASYNC=true
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
# compinit's compaudit security check (verifying no completion dir in $fpath
# is group/world-writable) costs ~25-30ms on every shell startup. It only
# needs to actually re-run once the dump is stale; skip it (-C) as long as
# .zcompdump is less than a day old.
_zcompdump_stale() {
  setopt localoptions extendedglob
  [[ -n ${1}(#qN.mh+24) ]]
}
if _zcompdump_stale "${ZDOTDIR:-$HOME}/.zcompdump"; then
  compinit
else
  compinit -C
fi
unfunction _zcompdump_stale

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
	find ./* -name "package.json" | xargs grep -l "\"$1\": \"*\"" | xargs -I {} bash -c "npm --prefix \$(dirname {}) install --no-audit --save $1@$2 &" | >/dev/null
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
        (cd "$dir" && npm install --legacy-peer-deps)
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

_comp_ssh_hosts() {
  local -a hosts
  hosts=(${(f)"$(awk '/^Host / {print $2}' ~/.ssh/config)"})
  _describe -t hosts 'SSH hosts' hosts
}
compdef _comp_ssh_hosts ssh

alias kssm="ps aux | grep '/opt/homebrew/bin/aws ssm start-session' | grep -v grep | awk '{print \$2}' | xargs kill"
exercism-cd() {
  exercism download "$@" || return

  local track exercise base dir
  base="$HOME/Exercism"

  track="$(printf '%s\n' "$*" | sed -nE 's/.*--track[= ]([^ ]+).*/\1/p')"
  exercise="$(printf '%s\n' "$*" | sed -nE 's/.*--exercise[= ]([^ ]+).*/\1/p')"

  if [ -z "$track" ] || [ -z "$exercise" ]; then
    echo "Usage: exercism-cd --track=<track> --exercise=<exercise> [other flags]" >&2
    return 1
  fi

  dir="$base/$track/$exercise"
  if [ -d "$dir" ]; then
    cd "$dir"
  else
    echo "Downloaded, but directory not found: $dir" >&2
    return 1
  fi
}

zle -N replace_multiple_dots
zle -N expand-dots-then-expand-or-complete
zle -N expand-dots-then-accept-line
bindkey '.' replace_multiple_dots
bindkey '^I' expand-dots-then-expand-or-complete
bindkey '^M' expand-dots-then-accept-line
bindkey '^[[Z' reverse-menu-complete
alias killdevcontainer="devcontainer exec --workspace-folder . hostname | xargs -r docker rm -f"

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

# Spaceship clears its whole segment cache on every precmd, so async segments
# (git, node, rust, etc.) render blank and then pop in once their background
# job resolves -- most noticeable as a flash-of-empty right after `cd`.
# Override the render-start function to skip that clear, so the *previous*
# value stays on screen until each section's own refresh overwrites it.
# Must be redefined after spaceship.zsh is sourced above (last definition
# wins), since it lives in our own dotfiles rather than the vendored plugin.
spaceship::core::start() {
  for section in $(spaceship::union $SPACESHIP_PROMPT_ORDER $SPACESHIP_RPROMPT_ORDER); do
    spaceship::core::refresh_section "$section"
  done
}

# Extend the same idea across shells/panes and per directory: SPACESHIP_CACHE
# is normally a flat, in-memory, per-process map keyed only by section name
# ("git" -> last computed value), so revisiting a directory you were in
# before -- even in a different pane -- shows whatever the *most recently
# computed* value happened to be, which is wrong if that came from a
# different project (e.g. `cd segment-tracking-plan` then back to
# `respond-io` would briefly show segment-tracking-plan's branch).
#
# Namespace the cache key by $PWD too, and persist it to a shared file that's
# preloaded before the first prompt renders. So each directory remembers its
# own last-known segment values, shared across every pane/shell, and only
# self-corrects (via the normal async refresh) if something in that specific
# directory actually changed since you were last there.
SPACESHIP_CACHE_PERSIST_FILE="$HOME/.cache/spaceship/segment_cache.zsh"
[[ -s "$SPACESHIP_CACHE_PERSIST_FILE" ]] && source "$SPACESHIP_CACHE_PERSIST_FILE" 2>/dev/null

spaceship::cache::get() {
  local key="$1"
  local cache_key="$PWD:$key"
  echo -n "${SPACESHIP_CACHE[$cache_key]}"
}

spaceship::cache::set() {
  local key="$1" value="$2"
  local cache_key="$PWD:$key"
  SPACESHIP_CACHE[$cache_key]="$value"
  mkdir -p "$(dirname "$SPACESHIP_CACHE_PERSIST_FILE")" 2>/dev/null
  typeset -p SPACESHIP_CACHE > "$SPACESHIP_CACHE_PERSIST_FILE" 2>/dev/null
}

# zsh-syntax-highligting & zsh-autosuggestions & spaceship theme
# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /usr/lib/spaceship-prompt/spaceship.zsh

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/weichun/.lmstudio/bin"
# End of LM Studio CLI section

# Build env for opencv usage settings -- only needed when actually compiling
# against opencv/llvm, not for everyday shell use. Was unconditional on every
# shell startup (the `xcode-select` call alone cost ~15ms per spawn); call
# `opencv-env` manually right before a build that needs it instead.
opencv-env() {
  export DYLD_FALLBACK_LIBRARY_PATH="$(xcode-select --print-path)/Toolchains/XcodeDefault.xctoolchain/usr/lib/"
  export LDFLAGS=-L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib
  export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
  export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
  export LDFLAGS="-L/opt/homebrew/opt/llvm/lib -lclang"
}

# zprof
