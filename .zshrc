#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
#if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
#  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
#fi

# Antigen plugins
source ~/antigen.zsh
# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git

# Syntax highlighting bundle.
# antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search

# git fzf plugin
antigen bundle 'wfxr/forgit'
#
# Tell Antigen that you're done.
antigen apply

# Bind up/down for history search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# Customize to your needs...
export PATH=$PATH:$HOME/bin

# export LC_ALL=en_US.UTF-8 
# Load history (and set to unlimited length)
HISTFILE=~/.zsh_history
HISTSIZE=10000
HISTFILESIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
#
# sets a nice prompt
PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# '

# maybe...?
export LC_ALL="en_US.UTF-8"

#adds powerline
#POWERLINE_PATH=$(which powerline-go)

# function powerline_precmd() {
#     PS1="$($POWERLINE_PATH -error $? -shell zsh)"
# }
# 
# function install_powerline_precmd() {
#   for s in "${precmd_functions[@]}"; do
#     if [ "$s" = "powerline_precmd" ]; then
#       return
#     fi
#   done
#   precmd_functions+=(powerline_precmd)
# }

# if [ "$TERM" != "linux" ] && [ -f $POWERLINE_PATH ];then
#    install_powerline_precmd
# fi
# adds autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

TRAPWINCH() {
  zle && { zle reset-prompt; zle -R }
}


# have ** use fd and ignore .gitignore files
 FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
_fzf_compgen_path() {
  fd --type f . "$1"
}

# FZF config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

#default to starting a new shell in tmux 
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#  tmux attach || tmux new

#fi


# TODO: uninstalled npm because it slow down shell startup. Find a solution so I can install again.

# export NVM_DIR="/Users/itai/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Automaticaly switch to version specified in .nvmrc
# autoload -U add-zsh-hook
# load-nvmrc() {
#   local node_version="$(nvm version)"
#   local nvmrc_path="$(nvm_find_nvmrc)"
#
#   if [ -n "$nvmrc_path" ]; then
#     local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
#
#     if [ "$nvmrc_node_version" = "N/A" ]; then
#       nvm install
#     elif [ "$nvmrc_node_version" != "$node_version" ]; then
#       nvm use
#     fi
#   elif [ "$node_version" != "$(nvm version default)" ]; then
#     echo "Reverting to nvm default version"
#     nvm use default
#   fi
# }
# add-zsh-hook chpwd load-nvmrc
# load-nvmrc
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#
#
# # Test if the shell is launched in Neovim's Terminal
# # prevent error: E117: Unknown function: stdpath
# # source:https://github.com/neovim/neovim/issues/9960
# if [[ -n "${NVIM_LISTEN_ADDRESS}" ]]
# then
#     # TODO update the path each time Vim has a major upgrade
#     export VIMRUNTIME=/usr/share/vim/vim81
# fi
