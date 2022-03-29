#export TERM=screen-256color
export TERM=xterm-256color

echo 🦈
# Load Antigen
source ~/antigen.zsh
# Load Antigen configurations
antigen init ~/.antigenrc
echo 🦒

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin:/usr/local/kubebuilder/bin
export PATH=$PATH:~/.local/lib/python2.7/site-packages
export PATH=$PATH:~/.local/lib/python3.5/site-packages
export PATH=$PATH:~/.local/lib/python3.6/site-packages
export PATH=$PATH:~/.local/bin
export PATH=$PATH:/snap/bin
export PATH=$PATH:/home/ben/bin

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

bindkey -M viins 'jk' vi-cmd-mode 
bindkey -M viins ',d' reloadrc
#bindkey -M viins ',r' history-incremental-pattern-search-backward
bindkey -M viins ',r' zaw-history
bindkey -M vicmd ',r' zaw-history
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
fzf-complete-from-tmux() {
    BUFFER+="$( \
        tmux capture-pane -pS -100000 | \
        tac | \
        pcregrep -o "[\w\d_\-\.\/]+" | \
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
bindkey -M viins ',t' zaw-tmux

eval "$(lua ~/z.lua --init zsh echo)"
# z.lua with fzf interactive
alias f="z -I"

alias vim="nvim"
alias vi="nvim"

# Override annoying expansions from zsh globalalias plugin
unalias -m "grep"

alias freeram="sudo sync ; echo 3 | sudo tee /proc/sys/vm/drop_caches"
alias p=python3
alias pip=pip3
alias pip2=/usr/bin/pip

alias dt="dotnet test"

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
zle -N run-with-less
zle -N run-with-rg
zle -N run-with-watch
bindkey -M viins ',l' run-with-less
bindkey -M vicmd ',l' run-with-less
bindkey -M viins ',g' run-with-rg
bindkey -M vicmd ',g' run-with-rg
bindkey -M viins ',w' run-with-watch
bindkey -M vicmd ',w' run-with-watch
bindkey -M viins ',v' edit-command-line
bindkey -M vicmd ',v' edit-command-line

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

alias pwshrc="nvim ~/.config/powershell/Microsoft.PowerShell_profile.ps1"
alias zshrc="nvim ~/.zshrc"

alias -s yaml=vim
alias -s go=vim

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
alias grbtt="git rebase -i HEAD~1010"
# Thank you @lmolkova!
alias screwit="git rebase --soft --root && git commit -m "i did it all in one commit"" 
alias grb="git rebase -i HEAD~5"
alias grbc="git rebase --continue"
alias grba="git rebase --abort"
alias grbe='vim $(git diff --name-only | uniq)'
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

# ----- Az ----- 

alias sub="az fzf subscription"
alias group="az fzf group -d"

# ----- Kubectl ----- 


function kc() {
    export KUBECONFIG="$1"
}

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

alias kd=k3d
alias k=kubectl
alias h=helm
source <(k completion zsh)
#alias k=microk8s.kubectl
#sudo snap alias microk8s.kubectl mk
alias kde='export KUBECONFIG="$(k3d get-kubeconfig)"'

# source <(kubectl completion zsh)
#source <(mk completion zsh | sed "s/kubectl/mk/g")

# Validator/ctrlarm
alias kgv='k get validations -A'
alias kdelv='k delete validations'
alias kgm='k get managedclusters -A'
alias kdelm='k delete managedclusters'
alias kgvo='k get validations --all -o yaml'
alias kgmo='k get managedclusters --all -o yaml'
alias -g nsv="-n validator-crd-system"

# Logs
alias kl='k logs'
alias klf='k logs -f'
function klval() {
    k logs -n validator-crd-system $(k get po -n validator-crd-system --no-headers | col 1) manager | less
}
function klflux() {
    k logs -n validator-crd-system $(k get po -n validator-crd-system --no-headers | col 1) manager | less
}
function klarm() {
    k logs -n validator-crd-system $(k get po -n validator-crd-system --no-headers | col 1) manager | less
}

# Namespace management
alias kgns='k get namespaces'
alias kens='k edit namespace'
alias kdns='k describe namespace'
alias kdelns='k delete namespace'
alias kcn='k config set-context $(k config current-context) --namespace'
alias kcu='k config use-context'

# Pod management
alias kgp='k get pods'
alias kgpw='kgp --watch'
alias kgpwide='kgp -o wide'
alias kep='k edit pods'
alias kdp='k describe pods'
alias kdelp='k delete pods'

# General aliases
alias kdel='k delete'
alias kdelf='k delete -f'

# Apply a YML file
alias kaf='k apply -f'

# Drop into an interactive terminal on a container
alias keti='k exec -ti'

alias ku="kustomize"
alias kku="kubectl kustomize"

function kns() {
    k config set-context --current --namespace=$1
}

funcion kub() {
    kustomize build $1
}

funcion kue() {
    kustomize build $1 | envsubst | kubectl apply -f -
}

funcion kua() {
    kustomize build $1 | kubectl apply -f -
}

funcion kud() {
    kustomize build $1 | kubectl delete -f -
}

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
    ssh-add ~/.ssh/id_rsa.github > /dev/null 2>&1
}

alias refreshdate="sudo ntpdate us.pool.ntp.org"

function cleanbuilds() {
    while read $build; do
        az pipelines build delete --org https://dev.azure.com/azure-sdk --project internal --id $build
    done
}

load-git-keys 

alias tmux='tmux -2'
if [ "$TMUX" = "" ]; then
    tmux attach-session -t wsl_tmux || tmux new-session -s wsl_tmux;
fi

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/usr/local/kubebuilder/bin
