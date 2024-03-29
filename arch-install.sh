#!/bin/bash
#SSH into installation from other device
passwd
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@archiso.local

#Disk Partitioning and partition Mounting
gdisk /dev/nvme0n1
x
z
y
y
cfdisk /dev/nvme0n1
    #512M EFI
    #16G SWAP
    #Rest for /mnt
mkfs.ext4 /dev/nvme0n1p3
mffs.vfat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
#Network Setup
iwctl
station wlan0 connect Network_5G
*password*
exit
#Mounting Drives
mount /dev/nvme0n1p3 /mnt
mkdir -p /mnt/EFI
#Installation
pacstrap /mnt base base-devel linux linux-headers linux-firmware amd-ucode git nano efibootmgr os-prober usbutils inetutils wpa_supplicant
#FSTAB generation
genfstab -pU /mnt >> /mnt/etc/fstab
#chrooting into installation
arch-chroot /mnt
#bootloader
    pacman -S grub
    grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB_Arch_Linux
    grub-mkconfig -o /boot/grub/grub.cfg
#Set Locale [En-IN.UTF-8]
    nano /etc/locale.conf
        en_US.UTF-8
        en_IN.UTF-8
#language setup
    locale-gen
    echo LANG=en_IN.UTF-8 > /etc/locale.conf
    export LANG=en_IN.UTF-8
#Hostname
    echo WompWompNigga > /etc/hostname
#pacman configuration
    nano /etc/pacman.conf
        [multilib]
        Include = /etc/pacman.d/mirrorlist
    pacman -Syu
   #User Setup 
    passwd *password*
    useradd -mG wheel,uucp -s /bin/bash nilay
    passwd nilay
    *password*

    EDITOR=nano visudo
        wheel ALL=(ALL) ALL
#DE installation
    pacman -S xorg-server plasma-meta dolphin firefox kate kdenlive dolphin-plugins ark baloo-widgets ffmpegthumbs kde-connect-kde kdegraphics-thumbnailers kdenetwork-filesharing kio-admin kio-extras kio-fuse kio-gdrive libappindicator-gtk3 xwaylandvideobridge noto-fonts noto-fonts-extra noto-color-emoji maliit-keyboard power-profiles-daemon switcheroo-control xdg-desktop-portal-gtk xsettingsd orca ark elisa filelight gwenview k3b kalk kamera kamoso kbackup kcalc kdf kfind kget kmail knotes kompare konsole krecorder okular partitionmanager spectacle yakuake xorg-xrandr discover packagekit-qt5 neofetch networkmanager gufw bluez bluez-utils pulseaudio-bluetooth ttf-dejavu ttf-opensans ttf-liberation ntfs-3g archlinux-wallpaper
    systemctl enable fstrim.timer
    systemctl enable sddm
    systemctl enable NetworkManager
    systemctl enable ufw
    systemctl enable bluetooth
    exit
    reboot

#Post-Installation
sudo gedit /etc/sysctl.d/99-swappiness.conf
    vm.swappiness=10
#Timezone    
timedatectl set-timezone Asia/Kolkata
timedatectl set-local-rtc 1 --adjust-system-clock

#AUR Package Installer
sudo pacman -S git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -S visual-studio-code-bin gimp rawtherapee obs-studio-amf darktable libreoffice-fresh gedit vlc telegram-desktop gpart mtools f2fs-tools ntfs-3g exfatprogs udftools jdk-openjdk gvfs-smb gvfs-mtp libmtp android-udev android-tools google-chrome skype spotify discord neofetch

# Nuke GnuPG
sudo rm -fr /etc/pacman.d/gnupg
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --refresh-keys
sudo pacman -Syu

#Trim
fstrim -v /

#Kernel
mkdir -p linux-g14 
cd linux-g14
git clone https://aur.archlinux.org/linux-g14.git
sudo gpg2 --locate-keys torvalds@kernel.org
makepkg
pacman -U linux-g14

#Kernel Headers
mkdir -p linux-g14-headers
cd linux-g14-headers
git clone https://aur.archlinux.org/linux-g14.git
sudo gpg2 --locate-keys torvalds@kernel.org
makepkg
pacman -U linux-g14-headers


#Laptop-Specific-Optimization [Ryzen Drivers, Raedon Drivers and AC alternative]
yay -S lm_sensors zenpower3-dkms zenmonitor3-git ryzenadj-git ryzen-controller-bin ryzen_smu amdgpu-pro-installer plasma6-applets-supergfxctl
nano /etc/pacman.conf
    [g14]
    SigLevel = Optional TrustAll
    Server = https://arch.asus-linux.org
    
sudo pacman -S asusctl supergfxctl rog-control-center
sudo pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils vulkan-icd-loader nvidia-settings nvidia-prime
sudo ryzencontroller --no-sandbox
sudo systemctl enable --now supergfxd.service


#GUI for pacman/AUR Packages
yay -S pamac-all polkit flatpak flatseal
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo

#Gaming Packages
yay -S lutris steam wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader mangohud-git lib32-mangohud-git goverlay-bin

#System Updates and AUR Kernel Updates
yay -Syyu



