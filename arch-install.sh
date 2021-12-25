#!/bin/sh

dd if=/dev/zero of=/swapfile bs=1G count=4 status=progress
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile   none  swap  defaults  0 0" >> /etc/fstab
ln -sf /usr/share/zoneinfo/Asia/Baghdad /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo "laptop" > /etc/hostname
mkinitcpio -P
passwd
pacman --noconfirm -S grub ntfs-3g os-prober
grub-install --target=i386-pc /dev/sda
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
pacman -Sy --noconfirm xorg-server xorg-xinit xorg-xsetroot xorg-xrandr \
xwallpaper sxiv zathura zathura-pdf-mupdf stow maim \
mpv cmus neovim newsboat unrar unzip wget pcmanfm calcurse \
zsh wpa_supplicant dhcpcd kodi xcompmgr transmission-gtk \
man-db htop alsa-utils libnotify dunst dash arc-gtk-theme
systemctl enable dhcpcd wpa_supplicant
rm /bin/sh
ln -s dash /bin/sh
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
useradd -m -G wheel -s /bin/zsh laith
passwd laith
