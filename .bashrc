# https://github.com/rupa/z
. ~/z.sh
# Shell prompt
PS1="\u:\W \u$ "

# Tern for vim
export no_proxy=localhost

CCL_DEFAULT_DIRECTORY=/Users/benbp/open_source_repos/clozure/ccl

# Fixes "RE error: illegal byte sequence" for sed search/replace on osx
# http://stackoverflow.com/questions/19242275/re-error-illegal-byte-sequence-on-mac-os-x
export LC_CTYPE=C 
export LANG=C

set -o vi

alias c="clear"
alias e="echo"
alias cb="cd -"
alias la="ls -alh"

alias ic="ifconfig"
alias sic="sudo ifconfig"

alias gs="git status"
alias ga="git add"
alias gap="git add -p"
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
alias gpl="git fetch --all --prune; git pull --rebase"
alias gf="git fetch --all --prune"
alias gre="git remote"
alias grei="git rebase -i"
alias grb2="git rebase -i HEAD~2"
alias grb3="git rebase -i HEAD~3"
alias grb5="git rebase -i HEAD~5"
alias gba="git branch -a"
alias gcp="git cherry-pick"
alias gst="git stash"
alias gstp="git stash pop"
alias ggrep="git grep -i --color --break --heading --line-number"

alias fgrep="find . | grep"
alias sfgrep="sudo find . | grep"

alias vbm="VBoxManage"

alias dl="diskutil list"
alias tmp="mkdir /tmp/test;cd /tmp/test"

alias sni="sudo node index.js"
alias snid="sudo node debug index.js"
alias ni="node index.js"
alias nid="node debug index.js"
alias nr="cd ~/.noderepl;node ~/.noderepl/repl.js;cd -"

alias d="docker"

function mt() {
    mocha $(find spec -name '*-spec.js')
}

function smt() {
    sudo mocha $(find spec -name '*-spec.js')
}

function mtd() {
    mocha debug $(find spec -name '*-spec.js')
}

function smtd() {
    sudo mocha debug $(find spec -name '*-spec.js')
}

alias rh="runhaskell"

# Remove vim swap files
alias rmswap="find . -name '*sw[m-p]'|xargs rm"

alias goog="ping 8.8.8.8"

alias warcraft="wine ~/.wine/drive_c/Program\ Files/Warcraft\ III\ Reign\ of\ Chaos\ \&\ The\ Frozen\ Throne/Frozen\ Throne.exe"

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

function cu() {
    if [[ -z "$1" ]];
    then
        cd ..
    else
        for ((i=1; i<=$1;i++))
        do
            cd ..
        done
    fi
}

function md() {
    if [[ -z "$2" ]];
    then
        mdfind "$1"
    else
        mdfind "$1" -onlyin "$2"
    fi
}

function gld() {
    branch=`git branch | awk '/\*/ {print $2;}'`
    # glg is an alias defined above
    glg master..$branch
}

function gp() {
    branch=`git branch | awk '/\*/ {print $2;}'`
    if [[ -z "$1" ]];
    then
        git push origin $branch
    else
        if [[ "$1" = "-f" ]];
        then
            if [[ "$branch" = "master" ]];
            then
                echo "You are an idiot. You almost force pushed to master!"
                echo "ABORTED: tried to force push to master!"
            else
                echo "Are you sure you want to force push to $branch?"
                read -p "(yes/no): " confirm
                if [[ "$confirm" = "yes" ]];
                then
                    git push origin $branch --force
                else
                    echo "Canceled"
                fi
            fi
        else
            git push origin $branch $1
        fi
    fi
}

function gamp() {
    branch=`git branch | awk '/\*/ {print $2;}'`
    if [[ "$branch" = "master" ]];
    then
        echo "ABORTED: tried push to master"
    else
        git add -u; git commit -m "$1"; git push origin $branch
    fi
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

export vbox="08:00:27:9b:d9:f4"

alias backuptosaga="rsync -av --update --stats --progress /Users/benbp/ saga:/owncloud1/cold_storage/renasar_laptop_backup"
