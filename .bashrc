# https://github.com/rupa/z
. ~/z.sh
# Shell prompt
PS1="\h:\W \u$ "

CCL_DEFAULT_DIRECTORY=/Users/benbp/open_source_repos/clozure/ccl

set -o vi

alias c="clear"
alias e="echo"

alias ic="ifconfig"
alias sic="sudo ifconfig"

alias gs="git status"
alias ga="git add"
alias gau="git add -u"
alias gm="git commit -m "
alias gam="git add -u; git commit -m"
alias grr="git add -u; git commit --amend"
alias gd="git diff --color"
alias gdc="git diff --color -U0"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit -n10"
alias glg="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"
alias gpo="git push origin"
alias gre="git remote"
alias grei="git rebase -i"
alias grb2="git rebase -i HEAD~2"
alias grb3="git rebase -i HEAD~3"
alias grb5="git rebase -i HEAD~5"
alias gba="git branch -a"
alias gcp="git cherry-pick"
alias ggrep="git grep -i --color --break --heading --line-number"

alias fgrep="find . | grep"
alias sfgrep="sudo find . | grep"

alias vbm="VBoxManage"

alias dl="diskutil list"
alias tmp="mkdir /tmp/test;cd /tmp/test"

alias d="docker"

function mkcd() {
    mkdir $1
    cd $1
}

function vmode() {
    if [[ "$1" == "on" ]];
    then
        set -o vi
    else
        set +o vi
    fi
}

function gp() {
    branch=`git branch | awk '/\*/ {print $2;}'`
    if [[ -z "$1" ]];
    then
        git push origin $branch
    else
        if [[ "$1" = "--force" ]];
        then
            echo "Are you sure you want to force push to $branch?"
            read -p "(yes/no): " confirm
            if [[ "$confirm" = "yes" ]];
            then
                git push origin $branch --force
            else
                echo "Canceled."
            fi
        else
            git push origin $branch $1
        fi
    fi
}

function gamp() {
    git add -u; git commit -m "$1"; git push origin `git branch | awk '/\*/ {print $2;}'`
}

function gsh() {
    if [[ -z "$1" ]];
    then
        sha=`git rev-parse HEAD`
    else
        sha=`git rev-parse HEAD~$1`
    fi
    git show $sha
}

function gitcl() {
    git clone git@github.com:$1
}

# Repeat last command with substitution
# e.g.
# wget site.com/file_a
# s file_a file_b
# becomes: wget site.com/file_b
# in the command line this is just ^$1^$2^, but I can't figure out how to get
# that to work in .bashrc
function s() {
    last=`history|tail -n 2|head -n 1|awk '{for (i=2;i<=NF;i++) printf $i" ";}'`
    `echo $last | sed s/$1/$2/`
}


alias brc="vi ~/dotfiles/.bashrc; cp ~/dotfiles/.bashrc ~;source ~/.bashrc"

alias ple="pylint -E"
function plw { pylint "$1" | grep W: ; }
function plc { pylint "$1" | grep C: ; }
export -f plw
export -f plc


verbose_commands=0

function cd_and_ls() {
    cd $1
    ls
}

function vv() {
    let verbose_commands=($verbose_commands+1)%2
    if [ $verbose_commands -eq 1 ]; then
        echo "verbose commands on"
        alias cd="cd_and_ls"
        alias ls="ls -lah"
    else
        echo "verbose commands off"
        unalias cd
        unalias ls
    fi
}

alias scf="vi /Users/benbp/.ssh/config"
alias skr="ssh-keygen -R"
alias edithosts="sudo vi /etc/hosts"

alias crashplanconfig="vi /Applications/CrashPlan.app/Contents/Resources/Java/conf/ui.properties"
