#!/bin/bash
script_dir=$(dirname "$0")

HOSTNAME=$(hostname)
if ! grep -q "$HOSTNAME" /etc/hosts; then
    echo "⚙️  Fixing hostname resolution..."
    echo "127.0.1.1 $HOSTNAME" | sudo tee -a /etc/hosts
fi

echo "🚀 Setting up zsh and oh-my-zsh for devcontainer..."
sudo apt-get update

echo "📦 Installing zsh..."
sudo apt-get install -y zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✅ oh-my-zsh is already installed. Skipping installation..."
else
    echo "📦 Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
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
cp $script_dir/dotfiles/.zshrc ~/.zshrc
cp $script_dir/dotfiles/.p10k.zsh ~/.p10k.zsh

if [ -f ~/.bashrc ]; then
    echo "⚙️  Converting .bashrc environment variables for zsh..."    
    echo -e "\n# Environment variables from .bashrc\n$(grep '^export ' ~/.bashrc | grep -v 'shopt\|function')\n" >> ~/.zshrc
    echo -e "\n# Aliases from .bashrc\n$(grep '^alias ' ~/.bashrc)\n" >> ~/.zshrc
    echo -e "\n# Source commands from .bashrc\n$(grep '^source ' ~/.bashrc)\n" >> ~/.zshrc
    if grep -Fxq '. "$HOME/.local/bin/env"' ~/.bashrc; then
      if ! grep -Fxq '. "$HOME/.local/bin/env"' ~/.zshrc; then
        echo '. "$HOME/.local/bin/env"' >> ~/.zshrc
      fi
    fi
fi

echo "⚙️  Convert default shell with /etc/passwd"    
current_user=$(whoami)
zsh_path=$(which zsh)
sudo sed -i "s|^\($current_user:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:\)/bin/bash$|\1$zsh_path|" /etc/passwd
