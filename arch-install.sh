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
7004371457
exit
#Mounting Drives
mount /dev/nvme0n1p3 /mnt
mkdir -p /mnt/EFI
#Installation
pacstrap /mnt base base-devel linux linux-headers linux-firmware amd-ucode git nano efibootmgr os-prober usbutils inetutils wpa_supplicant
genfstab -pU /mnt >> /mnt/etc/fstab
arch-chroot /mnt
    bootctl install
    nano /efi/loader/loader.conf
        default  arch.conf
        timeout  0
        console-mode max
        editor   no

    nano /efi/loader/entries/arch.conf
        title   Arch Linux (fallback initramfs)
        linux   /vmlinuz-linux
        initrd  /initramfs-linux-fallback.img
        options root=UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx rw
    nano /efi/loader/entries/arch-fallback.conf
        title   Arch Linux (fallback initramfs)
        linux   /vmlinuz-linux
        initrd  /initramfs-linux-fallback.img
        options root=UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx rw

    nano /etc/locale.conf
        en_US.UTF-8
        en_IN.UTF-8

    locale-gen
    echo LANG=en_IN.UTF-8 > /etc/locale.conf
    export LANG=en_IN.UTF-8
    timedatectl set-timezone Asia/Kolkata
    hwclock --systohc

    echo WompWompNigga > /etc/hostname

    nano /etc/pacman.conf
        [multilib]
        Include = /etc/pacman.d/mirrorlist
    pacman -Syu
    
    passwd 700437
    useradd -mG wheel,uucp -s /bin/bash nilay
    passwd nilay
    7004371457

    EDITOR=nano visudo
        wheel ALL=(ALL) ALL

    pacman -S xorg-server plasma-meta dolphin firefox kate kdenlive dolphin-plugins ark baloo-widgets ffmpegthumbs kde-connect-kde kdegraphics-thumbnailers kdenetwork-filesharing kio-admin kio-extras kio-fuse kio-gdrive libappindicator-gtk3 xwaylandvideobridge noto-sans noto-color-emoji maliit-keyboard power-profiles-daemon switcheroo-control xdg-desktop-portal-gtk xsettingsd orca ark elisa filelight gwenview k3b kalk kamera kamoso kbackup kcalc kdf kfind kget kmail knotes kompare konsole krecorder okular partitionmanager spectacle yakuake xorg-xrandr discover packagekit-qt5 neofetch networkmanager gufw bluez bluez-utils pulseaudio-bluetooth ttf-dejavu ttf-opensans ttf-liberation ntfs-3g 

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

sudo pacman -S git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -S visual-studio-code-bin gimp rawtherapee darktable libreoffice-fresh gedit vlc telegram-desktop gpart mtools f2fs-tools ntfs-3g exfatprogs udftools jdk-openjdk gvfs-smb gvfs-mtp libmtp android-udev android-tools google-chrome skype spotify discord neofetch

# Nuke GnuPG
sudo rm -fr /etc/pacman.d/gnupg
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --refresh-keys
sudo pacman -Syu

#Trim
fstrim -v /

#Laptop-Specific-Optimization
yay -S lm_sensors zenmonitor zenpower3-dkms zenmonitor3-git ryzenadj-git ryzen-controller-bin ryzen_smu
yay -S asusctl supergfxctl rog-control-center linux-g14 linux-g14-headers

nano /efi/loader/entries/arch.conf
    title   Arch Linux
    linux   /vmlinuz-linux-g14
    initrd  /initramfs-linux-g14.img
    options root=UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx rw
sudo pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils vulkan-icd-loader nvidia-settings

#Gaming
yay -S lutris steam wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader mangohud-git lib32-mangohud-git goverlay-bin



