. /Users/benbp/z.sh

alias c="clear"

alias ic="ifconfig"
alias sic="sudo ifconfig"

alias gits="git status"
alias gita="git add"
alias gitau="git add -u"
alias gitm="git commit -m "
alias gitd="git diff --color"
alias gitdc="git diff --color -U0"
alias gitco="git checkout"
alias gitcob="git checkout -b"
alias gitl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit -n10"
alias gitlg="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"
alias gitp="git push"
alias gitpom="git push origin master"
alias gitpo="git push origin"
alias gitre="git remote"
alias gitrei="git rebase -i"
alias gitrb2="git rebase -i HEAD~2"
alias gitrb3="git rebase -i HEAD~3"
alias gitrb5="git rebase -i HEAD~5"
alias gitba="git branch -a"
alias ggrep="git grep -i --color"

alias vbm="VBoxManage"

alias dl="diskutil list"

function gitsh() {
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

alias brc="vi ~/.bashrc; source ~/.bashrc"

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
