#!/usr/bin/env bash
set -euo pipefail

script_dir="$(dirname -- "${BASH_SOURCE[0]}")"
script_dir="$(cd -- "$script_dir" && pwd)"
readonly DOTFILES_DIR="${DOTFILES_DIR:-$script_dir}"
readonly RUST_TOOLCHAIN="${RUST_TOOLCHAIN:-1.98.1}"
readonly GITHUB_EMAIL="18647702+Kasra-G@users.noreply.github.com"
readonly DOTFILES_SSH_REMOTE="git@github.com:Kasra-G/df.git"

usage() {
  printf 'Usage: %s [install|check]\n' "$0"
}

configure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  command -v curl >/dev/null 2>&1 || {
    printf 'curl is required to install Homebrew.\n' >&2
    exit 1
  }

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  case "$(uname -s)" in
    Darwin)
      eval "$(/opt/homebrew/bin/brew shellenv)"
      ;;
    Linux)
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      ;;
    *)
      printf 'Unsupported operating system: %s\n' "$(uname -s)" >&2
      exit 1
      ;;
  esac
}

check_repository() {
  if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
    printf 'Clone the dotfiles repository to %s before running this script.\n' "$DOTFILES_DIR" >&2
    exit 1
  fi
}

configure_login_shell() {
  local zsh_path
  if [[ -x /bin/zsh ]]; then
    zsh_path=/bin/zsh
  elif ! zsh_path="$(command -v zsh)"; then
    printf 'Zsh is required before running this installer.\n' >&2
    exit 1
  fi

  if [[ "$SHELL" == "$zsh_path" ]]; then
    return
  fi
  if [[ -r /etc/shells ]] && ! grep -Fqx -- "$zsh_path" /etc/shells; then
    printf 'Zsh is not listed in /etc/shells: %s\n' "$zsh_path" >&2
    exit 1
  fi

  chsh -s "$zsh_path"
  printf 'Login shell changed to %s; it takes effect after the next login.\n' "$zsh_path"
}

setup_github_ssh() {
  local key="$HOME/.ssh/id_ed25519"
  local public_key="$key.pub"
  local allowed_signers="$HOME/.ssh/allowed_signers"
  local key_created=false

  mkdir -p "$HOME/.ssh"
  if [[ ! -f "$key" ]]; then
    ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$key"
    key_created=true
  fi
  if [[ ! -f "$public_key" ]]; then
    ssh-keygen -y -f "$key" >"$public_key"
  fi
  if [[ ! -f "$allowed_signers" ]]; then
    printf '%s %s\n' "$GITHUB_EMAIL" "$(cat "$public_key")" >"$allowed_signers"
  fi

  if [[ "$key_created" == true ]]; then
    printf '\nAdd this public key to GitHub:\n\n'
    cat "$public_key"
    printf '\n'
    if [[ ! -t 0 ]]; then
      printf 'The dotfiles remote remains on HTTPS until the key is registered.\n'
      return
    fi
    read -r -p 'Press Enter after adding the key to GitHub: '
  fi

  git -C "$DOTFILES_DIR" remote set-url origin "$DOTFILES_SSH_REMOTE"
}

pin_tmux_plugins() {
  local plugin revision directory current_revision
  while read -r plugin revision; do
    directory="$HOME/.config/tmux/plugins/$plugin"
    if [[ ! -d "$directory/.git" ]]; then
      printf 'Tmux plugin is missing: %s\n' "$plugin" >&2
      exit 1
    fi

    current_revision="$(git -C "$directory" rev-parse HEAD)"
    if [[ "$current_revision" != "$revision" ]]; then
      git -C "$directory" fetch --depth=1 origin "$revision"
      git -C "$directory" checkout --quiet --detach "$revision"
    fi
  done <"$DOTFILES_DIR/.config/tmux/plugins.lock"
}

check_tmux_plugins() {
  local plugin revision directory current_revision
  while read -r plugin revision; do
    directory="$HOME/.config/tmux/plugins/$plugin"
    if [[ ! -d "$directory/.git" ]]; then
      printf 'Tmux plugin is missing: %s\n' "$plugin" >&2
      exit 1
    fi

    current_revision="$(git -C "$directory" rev-parse HEAD)"
    if [[ "$current_revision" != "$revision" ]]; then
      printf 'Tmux plugin %s is at %s; expected %s.\n' "$plugin" "$current_revision" "$revision" >&2
      exit 1
    fi
  done <"$DOTFILES_DIR/.config/tmux/plugins.lock"
}

install_dotfiles() {
  configure_homebrew
  check_repository
  configure_login_shell
  setup_github_ssh

  git -C "$DOTFILES_DIR" submodule update --init --recursive
  brew bundle --file="$DOTFILES_DIR/Brewfile"
  mkdir -p "$HOME/.config/mise"
  install -m 0644 "$DOTFILES_DIR/.config/mise/config.toml" "$HOME/.config/mise/config.toml"
  stow --dir="$DOTFILES_DIR" --target="$HOME" --restow .

  mise -C "$HOME" install

  if ! command -v rustup >/dev/null 2>&1; then
    local rustup_bin
    rustup_bin="$(brew --prefix rustup)/bin"
    export PATH="$rustup_bin:$PATH"
  fi
  rustup set profile default
  rustup toolchain install "$RUST_TOOLCHAIN" --profile default
  rustup default "$RUST_TOOLCHAIN"

  local tpm="$HOME/.config/tmux/plugins/tpm/bin/install_plugins"
  if [[ -x "$tpm" ]]; then
    "$tpm"
  fi
  pin_tmux_plugins

  printf 'Portable setup complete. Start a new Zsh session, then run %s check.\n' "$0"
}

check_dotfiles() {
  configure_homebrew
  check_repository

  brew bundle check --file="$DOTFILES_DIR/Brewfile"
  cmp -s "$DOTFILES_DIR/.config/mise/config.toml" "$HOME/.config/mise/config.toml" || {
    printf 'mise config differs from %s.\n' "$DOTFILES_DIR/.config/mise/config.toml" >&2
    exit 1
  }
  stow --dir="$DOTFILES_DIR" --target="$HOME" --simulate --restow .
  zsh -n "$DOTFILES_DIR/.zshenv" "$DOTFILES_DIR/.zshrc"
  local -a shell_scripts=(
    "$DOTFILES_DIR/install.sh"
    "$DOTFILES_DIR/.local/bin/brew-install"
    "$DOTFILES_DIR/.local/bin/brew-uninstall"
    "$DOTFILES_DIR/.local/bin/tmux-workspace"
  )
  bash -n "${shell_scripts[@]}"
  shellcheck "${shell_scripts[@]}"
  shfmt -i 2 -ci -d "${shell_scripts[@]}"
  mise -C "$HOME" ls
  rustup show active-toolchain
  check_tmux_plugins

  printf 'Dotfiles checks passed.\n'
}

case "${1:-install}" in
  install)
    install_dotfiles
    ;;
  check)
    check_dotfiles
    ;;
  -h | --help)
    usage
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac
