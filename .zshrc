export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

typeset -TUx PATH path
path=("$HOME/.local/bin" $path)

if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

autoload -Uz compinit && compinit

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
export FZF_DEFAULT_OPTS="
    --color=fg:#f8f8f2,bg:#282a36,hl:#8be9fd
    --color=fg+:#a8a8a8,bg+:#44475a,hl+:#50fa7b
    --color=info:#bd93f9,prompt:#ff79c6,pointer:#ffb86c
    --color=marker:#ffb86c,spinner:#ff79c6,header:#6272a4
"

if [[ -t 0 && -t 1 ]]; then
  if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
  fi

  if [[ -r "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi

  function zvm_config() {
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
  }

  ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"
  ZINIT_REVISION="0bd474dbf0620f8a26e8359d382e70548a126c02"
  if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "${ZINIT_HOME:h}"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
  fi
  if [[ "$(git -C "$ZINIT_HOME" rev-parse HEAD)" != "$ZINIT_REVISION" ]]; then
    git -C "$ZINIT_HOME" fetch --depth=1 origin "$ZINIT_REVISION"
    git -C "$ZINIT_HOME" checkout --quiet --detach "$ZINIT_REVISION"
  fi

  source "$ZINIT_HOME/zinit.zsh"
  zinit ice ver"d05a1b00f9a61f9578bf9dc19b8451942dde8734"
  zinit light romkatv/powerlevel10k
  zinit ice ver"91cafe4a09b6670cb8e761aa413e5f7b9e00816f"
  zinit light jeffreytse/zsh-vi-mode
  zinit ice ver"0bfcb582e71d3abe604ce67bc0fe5a21f377507e"
  zinit light zsh-users/zsh-syntax-highlighting
  zinit ice ver"de02bb84ab0af51e328c6ae85ab5555397c31277"
  zinit light zsh-users/zsh-completions
  zinit ice ver"85919cd1ffa7d2d5412f6d3fe437ebdbeeec4fc5"
  zinit light zsh-users/zsh-autosuggestions
  zinit ice ver"5f3d129864ee4505043d88c3486224f1d75b692e"
  zinit light MichaelAquilina/zsh-you-should-use
  zinit snippet "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/0ee67f042872d1dfab74270c31867771ca35aef4/plugins/git/git.plugin.zsh"
  zinit snippet "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/0ee67f042872d1dfab74270c31867771ca35aef4/plugins/sudo/sudo.plugin.zsh"
  zinit snippet "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/0ee67f042872d1dfab74270c31867771ca35aef4/plugins/aws/aws.plugin.zsh"
  zinit snippet "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/0ee67f042872d1dfab74270c31867771ca35aef4/plugins/command-not-found/command-not-found.plugin.zsh"

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
  zstyle ':fzf-tab:*' fzf-options ${(z)FZF_DEFAULT_OPTS}

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

if [[ -r "$XDG_DATA_HOME/mise/completions.zsh" ]]; then
  source "$XDG_DATA_HOME/mise/completions.zsh"
fi

[[ -r "$HOME/.zshrc.amazon" ]] && source "$HOME/.zshrc.amazon"

path=("${(@)path:#${HOME}/scripts}")
path=("${(@)path:#${HOME}/.bun/bin}")
path=("${(@)path:#${XDG_DATA_HOME}/bob/nvim-bin}")
path=("${(@)path:#/home/linuxbrew/.linuxbrew/opt/node@22/bin}")
export PATH="${(j[:])path}"
