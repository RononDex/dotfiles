# Load all env variables
export ZSH="$ZDOTDIR/ohmyzsh"
source ~/.zprofile

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Load and execute custom profiles
if [ -d ~/.scripts ]; then
  if [ -f ~/.scripts/bashprofile ]; then
    source ~/.scripts/bashprofile
  fi
fi

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode zsh-autosuggestions zsh-syntax-highlighting z extract thefuck)

source $ZSH/oh-my-zsh.sh

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install

# All default aliases
if [ -d ~/.scripts ]; then
  if [ -f ~/.scripts/aliasrc ]; then
    source ~/.scripts/aliasrc
  fi
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

eval "$(starship init zsh)"
