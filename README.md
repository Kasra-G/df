# Dotfiles

Portable shell, Git, tmux, Vim, IdeaVim, Neovim, and runtime configuration for macOS and Linux. GNU Stow links the repository into the home directory.

## Install

The machine needs Git, curl, and Zsh. Clone the repository over HTTPS so initial setup does not depend on an existing SSH key:

```sh
git clone --recurse-submodules https://github.com/Kasra-G/df.git ~/.df
~/.df/install.sh
```

The installer:

1. Installs Homebrew if needed.
2. Sets `/bin/zsh` as the login shell when needed.
3. Reuses `~/.ssh/id_ed25519`, or generates it when absent and prompts you to register the public key with GitHub.
4. Installs the tools declared in `Brewfile`.
5. Links dotfiles with GNU Stow.
6. Installs the runtimes declared in `.config/mise/config.toml`.
7. Installs the configured Rust toolchain through rustup.
8. Installs tmux plugins through Tmux Plugin Manager (TPM).

Run the read-only checks after installation:

```sh
~/.df/install.sh check
```

Zinit installs pinned Zsh plugins when the first interactive shell starts. TPM installs tmux plugins and the bootstrap checks them against `.config/tmux/plugins.lock`. Neovim installs plugins from `lazy-lock.json` and editor tools through Mason when it starts.

## Homebrew packages

Use the tracked commands instead of calling `brew install` or `brew uninstall` directly:

```sh
brew-install PACKAGE
brew-install --cask CASK
brew-uninstall PACKAGE
brew-uninstall --cask CASK
```

`brew-install` installs the package before recording it in `Brewfile`. `brew-uninstall` verifies that the package is tracked, uninstalls it, and then removes its entry from `Brewfile`.

## Maintenance

After changing shell files, run:

```sh
shfmt -i 2 -ci -d install.sh .local/bin/brew-install .local/bin/brew-uninstall .local/bin/tmux-workspace
shellcheck install.sh .local/bin/brew-install .local/bin/brew-uninstall .local/bin/tmux-workspace
zsh -n .zshenv .zshrc
```

After changing Homebrew tools, update `Brewfile` and run `brew bundle check --file Brewfile`.
