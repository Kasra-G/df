#!/usr/bin/bash -e

echo "Installing brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
if [ "$(uname)" == "Darwin" ]; then
	echo 'MacOS Detected'
	(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	echo 'Linux Detected'
	(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> $HOME/.zprofile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
	echo 'OS not supported'
	exit 1
fi
echo "Installing utils"
brew install git stow coreutils fzf zoxide gpg tmux neovim
echo "Installing font"
if [ "$(uname)" == "Darwin" ]; then
 brew install --cask font-hack-nerd-font
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
 git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
 cd nerd-fonts
 git sparse-checkout add patched-fonts/Hack
 ./install.sh Hack
fi

echo "Generating SSH Key for Git"
ssh-keygen -t ed25519 -C "18647702+Kasra-G@users.noreply.github.com"
cat ~/.ssh/id_ed25519.pub
echo "SSH Private Key Printed above"
read -p "Press Enter once you have set up the SSH key on Github"
echo "Cloning dotfiles..."
git clone --recurse-submodules -j8 git@github.com:Kasra-G/df.git .df
cd .df
echo "Stowing"
stow .
# Additional utilities to install
echo "Installing additional utilities"
brew install btop go make maven tree ripgrep lazygit
echo "Installation complete, remember to create GPG Signing Key"
source $HOME/.zshrc
