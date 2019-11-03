# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle :compinstall filename '/home/ben/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=1000
setopt autocd extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install

### --------------- Custom ------------------
#

# autoload -Uz promptinit
# promptinit
# PROMPT="--------------------
# $ "


terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]

function insert-mode () { echo " " }
function normal-mode () { echo ":" }

precmd () {
    # Use non-breaking space to support tmux jump to previous command
    PS1=" $ "
}

function set-prompt () {
    case ${KEYMAP} in
      (vicmd)      VI_MODE="$(normal-mode)" ;;
      (main|viins) VI_MODE="$(insert-mode)" ;;
      (*)          VI_MODE="$(insert-mode)" ;;
    esac
    PS1="$VI_MODE$ "
}

function zle-line-init zle-keymap-select {
    set-prompt
    zle reset-prompt
}

# preexec () { print -rn -- $terminfo[el]; }

zle -N zle-line-init
zle -N zle-keymap-select

# export KEYTIMEOUT=1

function reloadrc() {
    source ~/.zshrc
}
zle -N reloadrc

bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins ',d' reloadrc
bindkey -M viins ',r' history-incremental-pattern-search-backward
