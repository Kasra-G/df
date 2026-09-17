export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
export FZF_DEFAULT_OPTS="
    --color=fg:#f8f8f2,bg:#282a36,hl:#8be9fd
    --color=fg+:#a8a8a8,bg+:#44475a,hl+:#50fa7b
    --color=info:#bd93f9,prompt:#ff79c6,pointer:#ffb86c
    --color=marker:#ffb86c,spinner:#ff79c6,header:#6272a4
"

if [[ -t 0 && -t 1 ]]; then
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi

  function zvm_config() {
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
  }

  ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
  if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
  fi

  source "$ZINIT_HOME/zinit.zsh"
  zinit ice depth=1; zinit light romkatv/powerlevel10k
  zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode
  zinit light zsh-users/zsh-syntax-highlighting
  zinit light zsh-users/zsh-completions
  zinit light zsh-users/zsh-autosuggestions
  zinit light undg/zsh-nvm-lazy-load
  zinit snippet "https://raw.githubusercontent.com/MichaelAquilina/zsh-you-should-use/refs/heads/master/you-should-use.plugin.zsh"
  zinit snippet OMZP::git
  zinit snippet OMZP::sudo
  zinit snippet OMZP::archlinux
  zinit snippet OMZP::aws
  zinit snippet OMZP::kubectl
  zinit snippet OMZP::kubectx
  zinit snippet OMZP::command-not-found

  autoload -Uz compinit && compinit
  zinit cdreplay -q
  [[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"

  bindkey -v
  bindkey '^[w' kill-region
  bindkey '^[[Z' autosuggest-accept
  bindkey '^?' backward-delete-char

  zstyle ':completion:*:git-checkout:*' sort false
  zstyle ':completion:*:descriptions' format '[%d]'
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  zstyle ':completion:*' menu no
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'gls --color $realpath'
  zstyle ':fzf-tab:*' query-string ''
  zstyle ':fzf-tab:*' fzf-options $(echo $FZF_DEFAULT_OPTS)

  eval "$(fzf --zsh)"

  if command -v brew >/dev/null 2>&1; then
    FZF_TAB_SCRIPT="$(brew --prefix fzf-tab 2>/dev/null)/share/fzf-tab/fzf-tab.zsh"
    [[ -r "$FZF_TAB_SCRIPT" ]] && source "$FZF_TAB_SCRIPT"
  fi

  [[ -t 0 ]] && export GPG_TTY="$(tty)"
fi

HISTSIZE=5000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

alias ls="gls --color"
function vim() { nvim "$@" }
alias c='clear'

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

if command -v keychain >/dev/null 2>&1; then
  eval "$(keychain --eval -q)"
fi

[[ -z "$SSH_AUTH_SOCK" ]] && eval "$(ssh-agent -s)" >/dev/null

if command -v brew >/dev/null 2>&1; then
  export BREW_HOME="$(brew --prefix)/bin"
  export PATH="$BREW_HOME:$PATH"
fi

export PATH="$XDG_DATA_HOME/bob/nvim-bin:$PATH"

[[ -s "$HOME/.config/envman/load.sh" ]] && source "$HOME/.config/envman/load.sh"

export NVM_DIR="$HOME/.config/nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

if [[ -x "$HOME/.local/bin/mise" ]]; then
  eval "$("$HOME/.local/bin/mise" activate zsh)"
fi
if [[ -t 0 && -t 1 && -r "$HOME/.local/share/mise/completions.zsh" ]]; then
  source "$HOME/.local/share/mise/completions.zsh"
fi

[[ -r "$HOME/.zshrc.amazon" ]] && source "$HOME/.zshrc.amazon"

typeset -TUx PATH path
export PATH="${(j[:])path}"
