################################################################################
## container aliases
################################################################################

alias alice="docker exec -it alice bash"
alias bob="docker exec -it bob bash"
alias router="docker exec -it router bash"
alias wire="wireshark --interface any -p -k &"
# alias pingall="ping6 ff02::1"

################################################################################
## coloring
################################################################################

# ls command with colors
alias ls='ls --color=auto'

# grep with colors
alias grep='grep --color=auto'

# bash prompt
# TODO: improve this
export PS1='\[\e[1;38;5;244m\]\t \[\e[1;36m\]\u@\H \[\e[1;33m\]\w \[\e[1;36m\]\$ \[\e[0m\]'

################################################################################
## bash features
## see: https://gist.github.com/moqmar/28dde796bb924dd6bfb1eafbe0d265e8
################################################################################

# search through history with up/down arrows
bind '"\e[A": history-search-backward' 2>/dev/null
bind '"\e[B": history-search-forward' 2>/dev/null

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar
