#!/bin/sh

#part1
printf '\033c'
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
sed '1,/^#part2$/d' arch-install.sh > /mnt/arch-install2.sh
chmod +x /mnt/arch-install2.sh
arch-chroot /mnt ./arch-install2.sh
exit 

#part2
printf '\033c'
# Setting up localtime, local and hostname.
ln -sf /usr/share/zoneinfo/Asia/Baghdad /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo "laptop" > /etc/hostname
# Make pacman colorful, concurrent downloads and Pacman eye-candy.
grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
sed -i "s/^#ParallelDownloads = 8$/ParallelDownloads = 5/;s/^#Color$/Color/" /etc/pacman.conf
# Use all cores for compilation.
sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf
# Grub install.
pacman --noconfirm -S grub ntfs-3g os-prober
grub-install /dev/sda
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
echo 'GRUB_CMDLINE_LINUX="root=/dev/sda2 rootfstype=ext4"' >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
# Install Packages.
pacman -Sy --noconfirm xorg-server xorg-xinit xorg-xrandr xorg-xbacklight qutebrowser xorg-xdpyinfo \
hsetroot sxiv zathura zathura-pdf-mupdf stow maim redshift slock xdotool libva-intel-driver curl unclutter \
mpv cmus neovim newsboat unrar unzip wget pcmanfm calcurse xclip xf86-video-intel fzf bc \
zsh dhcpcd bat xcompmgr transmission-cli unclutter opendoas python-adblock ueberzug \
mandoc htop alsa-utils xorg-xmodmap xcape xorg-setxkbmap libnotify dunst dash dosfstools zsh-autosuggestions
pacman -Scc
# Setting up users, mouse speed, keyboard langs ... etc.
passwd
systemctl enable dhcpcd
rm /bin/sh
ln -s dash /bin/sh
echo "permit nopass :wheel" >> /etc/doas.conf
useradd -m -G wheel -s /bin/zsh laith
passwd laith
echo 'Section "InputClass"
	Identifier "My Mouse"
	MatchIsPointer "yes"
	Option "AccelerationProfile" "-1"
	Option "AccelerationScheme" "none"
	Option "AccelSpeed" "-1"
EndSection' >> /etc/X11/xorg.conf.d/50-mouse-acceleration.conf
echo 'Section "InputClass"
  	Identifier "system-keyboard"
  	MatchIsKeyboard "on"
  	Option "XkbLayout" "us,ar"
  	Option "XkbModel" "pc105"
  	Option "XkbVariant" ",qwerty"
  	Option "XkbOptions" "grp:win_space_toggle"
EndSection' >> /etc/X11/xorg.conf.d/00-keyboard.conf
wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
doas cat hosts >> /etc/hosts && rm hosts
ai3_path=/home/laith/arch-install3.sh
sed '1,/^#part3$/d' arch-install2.sh > $ai3_path
chown laith:laith $ai3_path
chmod +x $ai3_path
su -c $ai3_path -s /bin/sh laith
exit

#part3
printf '\033c'
cd $HOME
# The AUR Helper.
git clone https://bitbucket.org/natemaia/baph.git
doas make -C ~/baph install
rm -rf baph
# Dotfiles.
git clone https://github.com/LaithOsama/.dotfiles.git 
cd .dotfiles && stow .
cd ..
# dwm, st, slstatus and dmenu (Suckless Tools).
git clone --depth=1 https://github.com/LaithOsama/dwm.git ~/.local/src/dwm
doas make -C ~/.local/src/dwm install
git clone --depth=1 https://github.com/LaithOsama/st.git ~/.local/src/st
doas make -C ~/.local/src/st install
git clone --depth=1 https://github.com/LaithOsama/dmenu.git ~/.local/src/dmenu
doas make -C ~/.local/src/dmenu install
git clone --depth=1 https://github.com/LaithOsama/slstatus.git ~/.local/src/slstatus
doas make -C ~/.local/src/slstatus install
# Others.
doas git clone https://github.com/zdharma-continuum/fast-syntax-highlighting /usr/share/zsh/plugins/fast-syntax-highlighting
doas wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
doas chmod a+rx /usr/local/bin/yt-dlp
git clone https://github.com/pystardust/ytfzf
doas make -C ~/ytfzf install doc
rm -rf ytfzf
mkdir -p ~/.cache/zsh ~/data ~/dl/git
touch ~/.cache/zsh/history
exit
