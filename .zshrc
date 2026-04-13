#export TERM=screen-256color
export TERM=xterm-256color

echo 🦈
# Load Antigen
source ~/antigen.zsh
# Load Antigen configurations
antigen init ~/.antigenrc
echo 🐋

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin:/usr/local/kubebuilder/bin
export PATH=$PATH:~/.local/lib/python2.7/site-packages
export PATH=$PATH:~/.local/lib/python3.5/site-packages
export PATH=$PATH:~/.local/lib/python3.6/site-packages
export PATH=$PATH:~/.local/bin
export PATH=$PATH:/snap/bin
export PATH=$PATH:$HOME/.dotnet/tools
export PATH=$PATH:/opt/nvim-linux-x86_64/bin

export DOTNET_ROOT=$HOME/.dotnet
export DOTNET_HOME=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT

function code {
  #/mnt/c/Users/bebroder/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code --remote wsl+Ubuntu $1
  # /mnt/c/Users/bebroder/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code $1
  /mnt/c/Users/bebroder/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code --folder-uri "vscode-remote://wsl+ubuntu$(pwd)"
}

function icode {
  #/mnt/c/Users/bebroder/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code --remote wsl+Ubuntu $1
  /mnt/c/Users/bebroder/AppData/Local/Programs/Microsoft\ VS\ Code\ Insiders/bin/code-insiders $1
}

alias approve="gh pr review --approve "

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle :compinstall filename '/home/ben/.zshrc'

autoload -Uz compinit
compinit
autoload bashcompinit
bashcompinit
source /etc/bash_completion.d/azure-cli
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=1000
setopt autocd extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install

### --------------- Custom ------------------

# autoload -U colors && colors
# autoload -U promptinit && promptinit

# Reset command output to normal font
preexec() { printf "\e[0m"; }

# Spellcheck suggestions for mis-typed commands
setopt correct

function insert-mode () { echo "%F{blue}⇉ ⇉ ⇉" }
function normal-mode () { echo "%F{green}↘ ↘ ↘" }

toggle-pwd-prompt() {
   if [[ -n "$_PWD_PROMPT_ON" ]]; then
       unset _PWD_PROMPT_ON
       PS1="$_ORIG_PS1"
   else
       _PWD_PROMPT_ON=1
       _ORIG_PS1="$PS1"
       PS1='%~ '"$PS1"
   fi
   zle reset-prompt
}

zle -N toggle-pwd-prompt


function set-prompt () {
    LAST_EXIT_CODE=$?
    ERR=""
    # ignore 0, ctrl-c
    if [[ $LAST_EXIT_CODE -ne 0 && $LAST_EXIT_CODE -ne 130 ]]; then 
        ERR="$LAST_EXIT_CODE "
    fi
    case ${KEYMAP} in
      (vicmd)      VI_MODE="$(normal-mode)" ;;
      (main|viins) VI_MODE="$(insert-mode)" ;;
      (*)          VI_MODE="$(insert-mode)" ;;
    esac
    # Space is a non-breaking space to support reverse prompt navigation with tmux search
    PS1="$ERR$VI_MODE %F{yellow}"
}

function zle-line-init zle-keymap-select {
    set-prompt
    zle reset-prompt
}

# preexec () { print -rn -- $terminfo[el]; }

zle -N zle-line-init
zle -N zle-keymap-select

# export KEYTIMEOUT=3

function reloadrc() {
    source ~/.zshrc
}
zle -N reloadrc

#function adv_history() {
#    BUFFER="$(atuin history list --cmd-only | fzf-tmux)"
#    zle end-of-line
#}
#zle -N adv_history

bindkey -M viins 'jk' vi-cmd-mode 
bindkey -M viins ',d' reloadrc
# Set search_mode to "fuzzy" in ~/.config/atuin/config.toml
bindkey ',r' _atuin_search_widget
#bindkey ',r' adv_history
#bindkey -M viins ',r' history-incremental-pattern-search-backward
bindkey -M viins '^r' zaw-history
bindkey -M vicmd '^r' zaw-history
# antigen bundle zsh-users/zsh-history-substring-search
# antigen apply
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
fzf-complete-from-tmux() {
    BUFFER+="$( \
        tmux capture-pane -pS -100000 | \
        tac | \
        pcre2grep -o "[\w\d_\-\.\/]+" | \
        awk '{ if (!seen[$0]++) print }' | \
        fzf-tmux --no-sort --exact \
    )"
    zle end-of-line
}
zle -N fzf-complete-from-tmux
bindkey -M viins ',c' fzf-complete-from-tmux
bindkey -M vicmd ',c' fzf-complete-from-tmux

bindkey -M viins ',z' zaw-git-recent-branches
bindkey -M viins ',s' zaw-git-log
bindkey -M viins ',a' zaw-ack
bindkey -M viins ',t' zaw-tmux
bindkey -M viins ',p' toggle-pwd-prompt
bindkey -M vicmd ',p' toggle-pwd-prompt

eval "$(lua ~/z.lua --init zsh echo)"
# z.lua with fzf interactive
alias f="z -I | fzf-tmux"

alias vim="nvim"
alias vi="nvim"

# Override annoying expansions from zsh globalalias plugin
unalias -m "grep"

alias freeram="sudo sync ; echo 3 | sudo tee /proc/sys/vm/drop_caches"
alias p=python3
alias pip=pip3
alias pip2=/usr/bin/pip

function run-with-less() {
    BUFFER+=" | less"
    zle accept-line
}
function run-with-rg() {
    BUFFER+=" | rg -i "
    zle end-of-line
}
function run-with-watch() {
    BUFFER="watch -n 2 '$BUFFER'"
    zle end-of-line
}
function run-with-xargs() {
    BUFFER+=" | xargs -I % bash -c '"
    zle end-of-line
}
zle -N run-with-less
zle -N run-with-rg
zle -N run-with-watch
zle -N run-with-xargs
bindkey -M viins ',l' run-with-less
bindkey -M vicmd ',l' run-with-less
bindkey -M viins ',g' run-with-rg
bindkey -M vicmd ',g' run-with-rg
bindkey -M viins ',w' run-with-watch
bindkey -M vicmd ',w' run-with-watch
bindkey -M viins ',v' edit-command-line
bindkey -M vicmd ',v' edit-command-line
bindkey -M viins ',x' run-with-xargs
bindkey -M vicmd ',x' run-with-xargs

. ~/zshrc.msft

function r() {
    rg -i $@
}

function ry() { 
    rg -i $@ -g '*.yaml' -g '*.yml'
}

function rf() { 
    rg -i "${@:2}" -g "*.$1"
}

function rgo() {
    rg -i $@ -g '!vendor*' -g '*.go'
}

alias gi="ginkgo"
alias gif="ginkgo --focus="

alias fz="fzf-tmux"

# quick aliasing for repetitive, but throwaway, tasks
function a() {
    alias $1="${*:2}"
    echo "Set up alias $1=\"${*:2}\""
}

alias rmswap="rm ~/.local/share/nvim/swap/*"

alias pwshrc="nvim ~/.config/powershell/Microsoft.PowerShell_profile.ps1"
alias zshrc="nvim ~/.zshrc"

alias -s yaml=vim
alias -s go=vim

function geu() {
    vim $(git diff --name-only)
}

alias gha="gh pr review --approve"

# Enable aliases with watch
alias watch="watch "
alias gs="git status"
alias ga="git add"
alias gap="git add -p"
alias gau="git add -u"
alias gm="git commit -m "
alias gam="git add -u; git commit -m"
alias grr="git add -u; git commit --amend --no-edit"
alias gd="git diff --color"
alias gdc="git diff --color -U0"
alias gco="git checkout"
alias gcob="git checkout -b benbp/"
alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit -n10"
alias glg="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"
alias gpo="git push origin"
alias gpu='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias gpf='git push -u fork $(git rev-parse --abbrev-ref HEAD)'
alias gpa='git push -u fork $(git rev-parse --abbrev-ref HEAD); git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias gpl="git fetch --all --prune; git pull --rebase"
alias gf="git fetch --all --prune"
alias gre="git remote"
alias grei="git rebase -i"
alias grb2="git rebase -i HEAD~2"
alias grb3="git rebase -i HEAD~3"
alias grb5="git rebase -i HEAD~5"
alias grbt="git rebase -i HEAD~10"
alias grb="git rebase -i HEAD~5"
alias grbm="git rebase origin/main"
alias grbc="git rebase --continue"
alias grba="git rebase --abort"
alias gba="git branch -a"
alias gcp="git cherry-pick"
alias gst="git stash"
alias gstp="git stash pop"
alias ggrep="git grep -i --color --break --heading --line-number"
alias rebase="git fetch --all --prune; git rebase origin/main"
alias gn="git fetch --all; git checkout origin/main; git checkout -b benbp/"

alias gui="git update-index --assume-unchanged"
alias guin="git update-index --no-assume-unchanged"
function groot() {
    cd $(git rev-parse --show-toplevel)
}
function gpa() {
    gh pr review --approve $1
}
# Open all git rebase conflicts in vim buffers
function grbe() {
    vim $(git status | rg both.modified | awk '{printf "%s ",$3}')
}
# Below doesn't work as well because it uses paths relative to repo root
# alias grbe='vim $(git diff --name-only | uniq)'

function update_gh() {
    pushd ~
    VERSION=$1
    echo "VERSION SHOULD NOT BE EMPTY: '$VERSION'. Run update_gh <version>"
    wget https://github.com/cli/cli/releases/download/v${VERSION}/gh_${VERSION}_linux_amd64.deb
    sudo dpkg -i gh_${VERSION}_linux_amd64.deb
    rm gh_${VERSION}_linux_amd64.deb
    gh version
    popd
}

# ----- Az ----- 

alias sub="az fzf subscription"
alias group="az fzf group -d"

# ----- Kubectl ----- 


function kc() {
    export KUBECONFIG="$1"
}

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

alias k=kubectl
alias h=helm
source <(k completion zsh)

# Logs
alias kl='k logs'
alias klf='k logs -f'

# Namespace management
alias kgns='k get namespaces'
alias kcn='k config set-context $(k config current-context) --namespace'
alias kcu='k config use-context'

# Pod management
alias kgp='k get pods'
alias kgpa='k get pods -A | rg -v kube-system'
alias kgpw='kgp --watch'
alias kgpwide='kgp -o wide'
alias kep='k edit pods'
alias kdp='k describe pods'

# Resource management
alias kgn='k get nodes'
alias ktn='k top nodes'
alias ktp='k top pods'
alias ktpa='k top pods -A'

# Apply a YML file
alias kaf='k apply -f'

# Drop into an interactive terminal on a container
alias keti='k exec -ti'

function x() {
    cat - | xargs -I % bash -c "$@"
}

function y() {
    echo $@
}

function col() {
    cmd='{print $'$1}
    cat - | awk $cmd
}

function load-git-keys() {
    eval `ssh-agent` > /dev/null 2>&1
    #ssh-add ~/.ssh/id_rsa.vsts > /dev/null 2>&1
    #ssh-add ~/.ssh/id_rsa.github.2 > /dev/null 2>&1
    ssh-add ~/.ssh/id_rsa.github > /dev/null 2>&1
}

# alias refreshdate="sudo ntpdate us.pool.ntp.org"
# alias refreshdate="echo 'sudo hwclock -s'; sudo hwclock -s"
alias refreshdate="echo 'sudo ntpdate time.windows.com'; sudo ntpdate time.windows.com"

load-git-keys 

# Set TERM_PROGRAM in vscode settings.json
#     "terminal.integrated.env.linux": {
#        "TERM_PROGRAM": "vscode", // Set this env so that in zshrc we can skip joining shared tmux session
#    }
alias tmux='tmux -2'
if [ "$TMUX" = "" ] && [ "$TERM_PROGRAM" != "vscode" ]; then
    tmux attach-session -t wsl_tmux || tmux new-session -s wsl_tmux;
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# https://github.com/ellie/atuin
export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"

export PATH="$PATH:/home/ben/bin"  # azsdk install path

export PATH=$PATH:/home/ben/bin

export PATH=/home/ben/.opencode/bin:$PATH
alias oc="opencode"

source '/home/ben/lib/azure-cli/az.completion'
