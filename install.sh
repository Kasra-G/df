#!/usr/bin/zsh

echo "Installing brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
echo "Installing utils"
brew install git stow coreutils fzf zoxide gpg
echo "Generating SSH Key for Git"
ssh-keygen -t ed25519 -C "18647702+Kasra-G@users.noreply.github.com"
pbcopy < ~/.ssh/id_ed25519.pub
echo "SSH Key copied to clipboard"
read -p "Press Enter once you have set up the SSH key on Github"
echo "Cloning dotfiles..."
git clone --recurse-submodules -j8 git@github.com:Kasra-G/df.git .df
cd .df
echo "Stowing"
stow .
# Additional utilities to install
echo "Installing additional utilities"
brew install btop
echo "Installation complete, remember to create GPG Signing Key"
source $HOME/.zshrc
