if [ "$TMUX" = "" ]; then
    tmux attach-session -t wsl_tmux || tmux new-session -s wsl_tmux;
fi

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

# autoload -U colors && colors
# autoload -U promptinit && promptinit

function insert-mode () { echo " " }
function normal-mode () { echo ":" }

function set-prompt () {
    case ${KEYMAP} in
      (vicmd)      VI_MODE="$(normal-mode)" ;;
      (main|viins) VI_MODE="$(insert-mode)" ;;
      (*)          VI_MODE="$(insert-mode)" ;;
    esac
    PS1="$VI_MODE--- $ "
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
