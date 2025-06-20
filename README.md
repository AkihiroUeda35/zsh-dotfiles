# zsh-dotfile 

Create [oh-my-zsh](https://ohmyz.sh/) environment with dotfiles with devcontainer. 
You can use oh-my-zsh with shared devcontainer.json and Dockerfile.  

## How to use in VS code.

Set User's `settings.json` of VScode as following.

```jsonc
  "dotfiles.repository": "https://github.com/AkihiroUeda35/zsh-dotfiles.git", // URL of this dotfiles repository
  "dotfiles.targetPath": "~/dotfiles", //repository will be cloned to this path
  "dotfiles.installCommand": "install.sh", // command to run after cloning the repository

   "terminal.integrated.defaultProfile.linux": "zsh", // set zsh as default shell ( if not found, bash will be used)
```

## Plugins for zsh

Following plugins are installed.

-zsh-autosuggestions  
-zsh-syntax-highlighting  
-zsh-bat  
-powerlevel10k  

Please see following code, if you want to add plugin, please add it to the `install.sh` file.

```bash 
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}/plugins/zsh-syntax-highlighting
git clone https://github.com/fdellwing/zsh-bat "$ZSH_CUSTOM/plugins/zsh-bat"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
```

powerlelve 10k setting is shown in the `dotfiles/.p10k.zsh` file.

## Compatibility with .bashrc

If you are adding environment variables in Dockerfile using `.bashrc`, they are automatically copied to `.zshrc` in the following code.

```bash
if [ -f ~/.bashrc ]; then
    echo "⚙️  Converting .bashrc environment variables for zsh..."    
    echo -e "\n# Environment variables from .bashrc\n$(grep '^export ' ~/.bashrc | grep -v 'shopt\|function')\n" >> ~/.zshrc
    echo -e "\n# Aliases from .bashrc\n$(grep '^alias ' ~/.bashrc)\n" >> ~/.zshrc
    echo -e "\n# Source commands from .bashrc\n$(grep '^source ' ~/.bashrc)\n" >> ~/.zshrc
fi
```