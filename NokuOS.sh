#!/bin/bash
# _   _       _           ____   _____                                       
#| \ | |     | |         / __ \ / ____\                                     
#|  \| | ___ | | ___   _| |  | | (___   NAME: NokuOS-Debian                        
#| . ` |/ _ \| |/ / | | | |  | |\___ \  RELEASE: ALPHA v.0.0.1
#| |\  | (_) |   <| |_| | |__| |____) | AUTHOR: Noku                        
#|_| \_|\___/|_|\_\\__,_|\____/|_____/  GITHUB: github.com/NokuWasTaken/NokuOS-Debian

clear

echo "###################################################################################"
echo "##Welcome to NokuOS-Debian, a version of NokuOS designed for Debian-based Distros##"
echo "###################################################################################"
echo ""
echo ""


##Checking if user is root
if [ "$(id -u)" = 0 ]; then
	echo "#############################################"
        echo "##Please use this Script as a normal User  ##"
        echo "##This Script wil make changen to the Home ##"
        echo "##Directory of the User Running it, which  ##"
        echo "##is in the Case of root /Root, a directory##"
        echo "##we dont want to mess with. You wil be    ##"
        echo "##asked for a sudo password when needed    ##"
        echo "#############################################"
        exit 1
fi

##Install Dialog and welcome Message
sudo apt install --noconfirm dialog

dialog --colors --msgbox "Welcome to NokuOS-Debain, a version of NokuOS for Debian-Based GNU/Linux Distributions. This Script will Install essential Packages   like The Kitty Terminal Emulator, the Fish Shell and also deploy my dotFiles, so everything is already well configured" 10 50

cd $HOME

mkdir .nokuos

cd .nokuos

##System Update

echo "######################"
echo "##Updating System...##"
echo "######################"

sudo apt-get upgrade && sudo apt-get upgrade

##Install core software

echo "########################"
echo "Installing Software...##"
echo "########################"

#Installing the Sofware in pkglist.txt

sudo apt install --noconfirm dselect

sudo dpkg --set-selections < pkglist.txt

sudo apt dselect-upgrade

#flatpak

flatpak install flathub com.github.alainm23.planner
 
#Vim-plug

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \ https://raw.githubusercontent.com/junegunn/vim-plu  g/master/plug.vim'

#AppImageLauncher

wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-lite-2.2.0-travis995-0f91801-x86_64.AppImage
chmod +x appimagelauncher-lite-2.2.0-travis995-0f91801-x86_64.AppImage
./appimagelauncher-lite-2.2.0-travis995-0f91801-x86_64.AppImage

#Marktext
wget https://github.com/marktext/marktext/releases/latest/download/marktext-x86_64.AppImage
chmod +x marktext-x86_64.AppImage
./marktext-x86_64.AppImage
killall marktext

#Shell-color-scripts

git clone https://gitlab.com/dwt1/shell-color-scripts.git
cd shell-color-scripts
rm -rf /opt/shell-color-scripts || return 1
sudo mkdir -p /opt/shell-color-scripts/colorscripts || return 1
sudo cp -rf colorscripts/* /opt/shell-color-scripts/colorscripts
sudo cp colorscript.sh /usr/bin/colorscript
cd $HOME/.nokuos


##Installing DotFiles

echo "##########################"
echo "##Installing dotFiles...##"
echo "##########################"

git clone https://github.com/NokuWasTaken/dotFiles.git

echo "cloned dotFiles repo"

cd dotFiles

##Shell dotFiles

echo "moving shell dotFiles"

mv .bashrc $HOME
mv .zshrc $HOME
mv config.fish $HOME/.config/fish/config.fish

echo "moving shell dotFiles completed"

##.vimrc

echo "moving .vimrc"

mv .vimrc $HOME

echo "moving .vimrc completed"

##installing xmonad config

echo "moving .xmonad folder"

mv -r .xmonad $HOME

echo "moving .xmonad folder completed"

##change User Shell

echo "#####################"
echo "##Changing Shell...##"
echo "#####################"

echo "Which Shell do you wanna use?"
echo "1) fish"
echo "2) zsh"
echo "3) bash"
echo "4) abort"
read -p "Enter your Choice (1-4) :" shellchange

if [ "$shellchange" = "1" ]
then
	chsh -s /usr/bin/fish
elif [ "$shellchange" = 2 ]
then
	chsh -s /bin/zsh
elif [ $shellchange = "3" ]
then
        chsh -s /bin/bash
else
        echo "aborted"
fi
