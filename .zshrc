export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
  ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
}

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # MacOS
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]] then
  # Linux
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
export GPG_TTY=$(tty)
export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
export FZF_DEFAULT_OPTS="
    --color=fg:#f8f8f2,bg:#282a36,hl:#8be9fd
    --color=fg+:#a8a8a8,bg+:#44475a,hl+:#50fa7b
    --color=info:#bd93f9,prompt:#ff79c6,pointer:#ffb86c
    --color=marker:#ffb86c,spinner:#ff79c6,header:#6272a4
"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [[ -z "$ZINIT_HOME" || ! -d "$ZINIT_HOME" ]]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in better vi mode
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode
# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light undg/zsh-nvm-lazy-load

# Add in snippets
zinit snippet "https://raw.githubusercontent.com/MichaelAquilina/zsh-you-should-use/refs/heads/master/you-should-use.plugin.zsh"
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
#bindkey '^p' history-search-backward
#bindkey '^n' history-search-forward
bindkey -v
bindkey '^[w' kill-region
bindkey '^[[Z' autosuggest-accept
bindkey "^?" backward-delete-char

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'gls --color $realpath'
zstyle ':fzf-tab:*' query-string ''
zstyle ':fzf-tab:*' fzf-options $(echo $FZF_DEFAULT_OPTS)


# Aliases
alias ls="gls --color"

function vim() { nvim "$@" }
alias c='clear'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

typeset -TUx PATH path

export PATH="${(j[:])path}"
