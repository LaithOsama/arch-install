#!/bin/sh

git clone https://github.com/PandaFoss/baph.git
sudo make -C ~/baph install
rm -rf baph

baph -i zsh-autosuggestions-git zsh-fast-syntax-highlighting-git nerd-fonts-jetbrains-mono ttf-material-design-icons-git 

git clone https://github.com/LaithOsama/dotfiles.git
cd dotfiles
stow .
cd ..

git clone --depth=1 https://github.com/LaithOsama/dwm.git ~/.local/src/dwm
sudo make -C ~/.local/src/dwm install
git clone --depth=1 https://github.com/LaithOsama/st.git ~/.local/src/st
sudo make -C ~/.local/src/st install
git clone --depth=1 https://github.com/LaithOsama/dmenu.git ~/.local/src/dmenu
sudo make -C ~/.local/src/dmenu install
git clone https://github.com/LaithOsama/walls.git

sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp

wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts

curl -s 'https://download.opensuse.org/repositories/home:/ungoogled_chromium/Arch/x86_64/home_ungoogled_chromium_Arch.key' | sudo pacman-key -a -
echo '
[home_ungoogled_chromium_Arch]
SigLevel = Required TrustAll
Server = https://download.opensuse.org/repositories/home:/ungoogled_chromium/Arch/$arch' | sudo tee --append /etc/pacman.conf
sudo pacman -Sy ungoogled-chromium
chmod +x ~/.local/bin/setbg ~/.local/bin/bar.sh
mkdir -p ~/.cache/zsh ~/data ~/dl
touch ~/.cache/zsh/history
