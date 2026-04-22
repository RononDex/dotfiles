# Load all env variables
source ~/.zprofile

# Load and execute custom profiles
if [ -d ~/.scripts ]; then
  if [ -f ~/.scripts/bashprofile ]; then
    source ~/.scripts/bashprofile
  fi
fi

# ZPLUG config
source ${ZPLUG_HOME}/init.zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    echo; zplug install
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

# All default aliases
if [ -d ~/.scripts ]; then
  if [ -f ~/.scripts/aliasrc ]; then
    source ~/.scripts/aliasrc
  fi
fi

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

ZSH_COLORIZE_TOOL=chroma
ZSH_COLORIZE_CHROMA_FORMATTER=terminal256

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 
eval "$(starship init zsh)"
