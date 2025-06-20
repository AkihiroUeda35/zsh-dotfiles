#!/bin/bash

echo "🚀 Setting up zsh and oh-my-zsh for devcontainer..."
sudo apt-get update

echo "📦 Installing zsh..."
sudo apt-get install -y zsh
echo "📦 Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install plugins
echo "📦 Installing plugins..."
sudo apt-get install -y bat
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}/plugins/zsh-syntax-highlighting
git clone https://github.com/fdellwing/zsh-bat "$ZSH_CUSTOM/plugins/zsh-bat"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

echo "⚙️  Copying .zshrc and .p10k.zsh..."    
cp ~/dotfiles/.zshrc ~/.zshrc
cp ~/dotfiles/.p10k.zsh ~/.zsh

sudo chsh -s "$(which zsh)" "$USER"

if [ -f ~/.bashrc ]; then
    echo "⚙️  Converting .bashrc environment variables for zsh..."    
    grep '^export ' ~/.bashrc | grep -v 'shopt\|function' >> ~/.zshrc
    grep '^alias ' ~/.bashrc >> ~/.zshrc
    grep '^source ' ~/.bashrc >> ~/.zshrc
fi
source ~/.zshrc
