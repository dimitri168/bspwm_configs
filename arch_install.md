# Краткое руководство по тривиальной установке Arch Linux

## Network

### iwctl

`iwctl`

`station wlan0 connect linksys_media`

### Cellular modem

`mmcli -L` 

выдаст строку типа `/org/freedesktop/ModemManager1/Modem/6 [Lenovo] N5321 gw`

6 - индекс модема, указываем в следующей команде

`mmcli -m 6 --simple-connect="apn=internet.beeline.kz"`

## Русская консоль с переключением по CapsLock в live-режиме

`loadkeys ruwin_cplk-UTF-8`
`setfont cyr-sun16`

можно `ter-u18b` - русскоязычный жирный шрифт, или `ter-u18n` - для обычного начертания

## Проверка режима загрузки UEFI

`ls /sys/firmware/efi/efivars`

вылезет куча всякого, значит загружено в UEFI.

`cat /sys/firmware/efi/fw_platform_size`

покажет разрядность окружения EFI.

## Local Mirror

Работаем с <mark>/etc/pacman.d/mirrorlist</mark>

Домашний сервак (сейчас не работает)

Server = [http://192.168.2.136:8080/$repo/os/$arch]()

Казахстанские зеркала

Server = [https://mirror.ps.kz/archlinux/$repo/os/$arch]()

Server = [https://mirror.hoster.kz/archlinux/$repo/os/$arch]()	# плохо работает

Еще можно запустить `reflector` - отранжировать по скорости и доступности зеркал с записью в <mark>mirrorlist</mark>

`reflector --country Kazakhstan,Russia --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist`

В справке `man reflector` есть примеры.

## Разметка диска

`cfdisk /dev/sda`
Стандартно - 1Гб на EFI, остальное на root. Swap - файлом.

Форматирование и монтирование. Монтирование в /mnt/boot/efi считается устаревшим

`mkfs.ext4 /dev/sda2`

`mount /dev/sda2 /mnt`

`mkfs.fat -F32 /dev/sda1`

`mkdir -p /mnt/boot`

`mount /dev/sda1 /mnt/boot`

Swap потом в установленной системе делаем файлом.

## Загрузка базы и переход в систему.

`pacstrap /mnt base linux-zen linux-firmware intel-ucode`

`pacstrap /mnt nano dhcpcd man-db man-pages texinfo networkmanager terminus-font ttf-terminus-nerd sudo vi`

FSTAB с дисками по UUID

`genfstab -U /mnt >> /mnt/etc/fstab`

`arch-chroot /mnt`

## Hostname - имя компьютера

`nano /etc/hostname`

## Локализация

Файл <mark>/etc/vconsole.conf</mark>

```
KEYMAP=ruwin_cplk-UTF-8
FONT=ter-u22b
```

Файл <mark>/etc/locale.conf</mark>

```
LANG=ru_RU.UTF-8
```

Файл <mark>/etc/locale.gen</mark> - раскомментировать нужные локали и выполнить

`locale-gen`

## Дата

`timedatectl set-timezone Asia/Almaty`

## Загрузчик

### Ставим grub2

`pacman -S grub2 efibootmgr`

`grub-install /dev/sda`

`grub-mkconfig -o /boot/grub/grub.cfg`

### Или systemd-boot

`bootctl install`

Файл <mark>/boot/loader/loader.conf</mark>

```
default  arch.conf
timeout  4
console-mode max
```

max - максимальное разрешение экрана. Также есть варианты 0, 1, auto, keep.

Файл <mark>/boot/loader/entries/arch.conf</mark>

```
title   Arch Linux
linux   /vmlinuz-linux-zen
initrd  /intel-ucode.img
initrd  /initramfs-linux-zen.img
options root=UUID=12dad10e-2218-4796-ad89-2337030b4379 rw
```

UUID можно посмотреть так:

`lsblk -o NAME,SIZE,UUID`

Делаем пароль root

`passwd`

На этом этапе можно перезагрузить.

## Пользователи

`useradd -m -g users -G wheel,video -s /bin/bash MYUSERNAME ; passwd MYUSERNAME`

Отредактировать <mark>/etc/sudoers</mark> - раскомментировать `%wheel ALL=(ALL:ALL) ALL`

`pacman -S xdg-user-dirs`

`xdg-user-dirs-update` - прописывает в каталог пользователя стандартные директории

## YAY

`pacman -S --needed git base-devel`

`mkdir ~/git; cd git`

`git clone https://aur.archlinux.org/yay.git`

`cd yay`

`makepkg -si`

## XORG

`pacman -S xorg xorg-server xorg-apps mesa libva-intel-driver vulkan-intel`

`pacman -S xf86-input-synaptics xorg-xinit xterm xorg-xclock`

Установить пакет`libva-intel-driver` - для старых встроек Intel. Для процов новее 8-го поколения `intel-media-driver`

## Звук

### PulseAudio

`pacman -S pulseaudio pulseaudio-bluetooth pavucontrol`

### Pipewire

`pacman -S pipewire pipewire-alsa gst-plugin-pipewire pipewire-pulse`

Из под **ПОЛЬЗОВАТЕЛЯ** включаем сервисы

`systemctl --user enable pipewire.service`

`systemctl --user enable pipewire-pulse.service`

### Bluetooth

`pacman -S bluez bluez-utils blueman`

`systemctl enable bluetooth.service`

## XFCE4

`pacman -S xfce4 xfce4-goodies gvfs gvfs-smb network-manager-applet lightdm`

`yay -S mugshot`

## Lightdm autologin

`sudo systemctl enable lightdm`

Редактируем <mark>/etc/lightdm/lightdm.conf</mark>

```
[Seat:*]
autologin-user=USERNAME
groupadd -r autologin
gpasswd -a USERNAME autologin
```

`sudo systemctl start lightdm`

## Codecs and player

`yay -S gstreamer gstreamer-vaapi gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly`

`yay -S mpv`

## Политики

`pacman -S gnome-keyring polkit-gnome seahorse`

## Разное

`yay -S ncdu p7zip mc engrampa geany`

`yay -S firefox firefox-i18n-ru openssh ttf-hack`

`yay -S dropbox`

`yay -S pacman-contrib` - всякие pactree, paccache 

`sudo systemctl enable paccache.timer` - для удаления кэша раз в неделю

## Делаем Swap

### Файлом

`fallocate -l 8G /swapfile`

`chmod 600 /swapfile`

`mkswap /swapfile`

`swapon /swapfile`

Изменяем <mark>/etc/fstab</mark>

`/swapfile none swap defaults,discard 0 0`

### С помощью zram-generator. По-умолчанию создается устройство размером в половину ОЗУ.

`sudo pacman -S zram-generator`

Вставить в <mark>/etc/systemd/zram-generator.conf</mark>

`[zram0]`

Остальные параметры гуглить.

Выполнить

`systemctl daemon-reload`

и стартовать

`systemctl start systemd-zram-setup@zram0.service`

Проверка работоспособности

`swapon --show`

## Монтирование NTFS драйвером ядра (возможно какая-то хрень)

`yay -S udisks2`

В качестве обходного пути добавьте следующую опцию в секции `[defaults]` в файле <mark>/etc/udisks2/mount_options.conf</mark>:

`ntfs_defaults=uid=$UID,gid=$GID,noatime,prealloc`

## Redshift (гамма экрана в зависимости от времени)

Вставить в <mark>/etc/geoclue/geoclue.conf</mark>

```
url=https://location.services.mozilla.com/v1/geolocate?key=geoclue
[redshift]
allowed=true
system=false
users=
```

## Красота в терминале

`bat` - цветная замена cat

`dfc` - цветная замена df

`lsd` - замена ls с цветами и иконками

`zoxide` - умный переход по местам, ранее посещенным с помощью cd

`fish` - замена для bash

## Настройка fish

Файл <mark>$HOME/.config/fish/config.fish</mark>

```
if status is-interactive
##Commands to run in interactive sessions can go here
    set -g fish_greeting ""
    alias ls='lsd'
    alias cat='bat'
    alias df='dfc'
    zoxide init fish | source
end
```

## BSPWM

`yay -S bspwm sxhkd polybar dmenu dunst alacritty picom fastfetch btop tapper rofi`