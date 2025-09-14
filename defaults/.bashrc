#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Load and execute custom profiles
if [ -d ~/.scripts ]; then
    if [ -f ~/.scripts/bashprofile ]; then
        source ~/.scripts/bashprofile
    fi
fi

# All default aliases
if [ -d ~/.scripts ]; then
    if [ -f ~/.scripts/aliasrc ]; then
        source ~/.scripts/aliasrc
    fi
fi

source ~/.profile
