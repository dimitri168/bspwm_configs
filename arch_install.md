# Краткое руководство по установке Arch Linux, Xorg, BSPWM и немного XFCE

> Почти всё выполняется от пользователя `root`. Команда `yay`, а также редактирование файлов в каталоге пользователя всегда выполняются от текущего пользователя.

Скачиваем свежий образ с официального сайта, записываем на флешку с `ventoy`, или каким-либо другим способом, и поехали...

- [Краткое руководство по установке Arch Linux, Xorg, BSPWM и немного XFCE](#краткое-руководство-по-установке-arch-linux-xorg-bspwm-и-немного-xfce)
  - [Live-сессия](#live-сессия)
    - [Сеть в live-сессии](#сеть-в-live-сессии)
      - [iwctl](#iwctl)
      - [Cellular modem](#cellular-modem)
    - [Русская консоль с переключением по CapsLock в live-режиме](#русская-консоль-с-переключением-по-capslock-в-live-режиме)
    - [Проверка режима загрузки UEFI](#проверка-режима-загрузки-uefi)
    - [Зеркала](#зеркала)
    - [Разметка диска](#разметка-диска)
    - [Загрузка базы и переход в систему.](#загрузка-базы-и-переход-в-систему)
    - [Hostname - имя компьютера](#hostname---имя-компьютера)
    - [Локализация](#локализация)
    - [Дата](#дата)
    - [Загрузчик](#загрузчик)
      - [Ставим grub2](#ставим-grub2)
      - [Или systemd-boot](#или-systemd-boot)
    - [Сеть для установленной системы](#сеть-для-установленной-системы)
    - [Завершение установки](#завершение-установки)
  - [Настройки в установленной системе](#настройки-в-установленной-системе)
    - [Сеть](#сеть)
    - [Пользователи](#пользователи)
    - [YAY](#yay)
    - [XORG](#xorg)
    - [Звук](#звук)
      - [PulseAudio](#pulseaudio)
      - [или Pipewire](#или-pipewire)
      - [Bluetooth](#bluetooth)
    - [Политики](#политики)
    - [Разное](#разное)
    - [Делаем Swap](#делаем-swap)
      - [Файлом](#файлом)
      - [или с помощью zram-generator. По-умолчанию создается устройство размером в половину ОЗУ.](#или-с-помощью-zram-generator-по-умолчанию-создается-устройство-размером-в-половину-озу)
    - [Монтирование NTFS драйвером ядра (возможно какая-то хрень)](#монтирование-ntfs-драйвером-ядра-возможно-какая-то-хрень)
    - [Redshift (гамма экрана в зависимости от времени)](#redshift-гамма-экрана-в-зависимости-от-времени)
    - [Красота в терминале](#красота-в-терминале)
    - [Настройка fish](#настройка-fish)
    - [BSPWM](#bspwm)
    - [XFCE4](#xfce4)
    - [Lightdm autologin](#lightdm-autologin)
    - [Видеокодеки](#видеокодеки)
    - [MPV](#mpv)


## Live-сессия

### Сеть в live-сессии

#### iwctl

`iwctl`

`station wlan0 connect ваш_ssid`

#### Cellular modem

`mmcli -L` 

выдаст строку типа `/org/freedesktop/ModemManager1/Modem/6 [Lenovo] N5321 gw`

6 - индекс модема, указываем в следующей команде

`mmcli -m 6 --simple-connect="apn=internet.beeline.kz"`

### Русская консоль с переключением по CapsLock в live-режиме

`loadkeys ruwin_cplk-UTF-8`

`setfont cyr-sun16`

можно `ter-u18b` - русскоязычный жирный шрифт, или `ter-u18n` - для обычного начертания. Размер подбираем по разрешению экрана.

### Проверка режима загрузки UEFI

`ls /sys/firmware/efi/efivars`

вылезет куча всякого, значит загружено в UEFI.

`cat /sys/firmware/efi/fw_platform_size`

покажет разрядность окружения EFI.

### Зеркала

Работаем с <mark>/etc/pacman.d/mirrorlist</mark>

Казахстанские зеркала

Server = [https://mirror.ps.kz/archlinux/$repo/os/$arch]()

Server = [https://mirror.hoster.kz/archlinux/$repo/os/$arch]()	# плохо работает

Можно запустить `reflector` - отранжировать по скорости и доступности зеркал с записью в <mark>mirrorlist</mark>

`reflector --country Kazakhstan,Russia --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist`

В справке `man reflector` есть примеры.

### Разметка диска

`cfdisk /dev/sda`

Стандартно - 1Гб на EFI, остальное на root. Swap делаем файлом.

Форматирование и монтирование. Монтирование в /mnt/boot/efi считается устаревшим.

`mkfs.ext4 /dev/sda2`

`mount /dev/sda2 /mnt`

`mkfs.fat -F32 /dev/sda1`

`mkdir -p /mnt/boot`

`mount /dev/sda1 /mnt/boot`

Swap потом в установленной системе делаем файлом.

### Загрузка базы и переход в систему с помощью `arch-chroot`. Ядро ставим `linux-zen`.

`pacstrap /mnt base linux-zen linux-firmware intel-ucode`

`pacstrap /mnt nano dhcpcd man-db man-pages texinfo networkmanager terminus-font ttf-terminus-nerd sudo vi`

`FSTAB` с дисками по `UUID`

`genfstab -U /mnt >> /mnt/etc/fstab`

`arch-chroot /mnt`

### Hostname - имя компьютера

`nano /etc/hostname` - придумать имя компьютеру.

### Локализация

Файл <mark>/etc/vconsole.conf</mark>.  Переключение раскладки клавишей CapsLock

```
KEYMAP=ruwin_cplk-UTF-8
FONT=ter-u22b
```

Файл <mark>/etc/locale.conf</mark>. Стандартная локаль системы.

```
LANG=ru_RU.UTF-8
```

Файл <mark>/etc/locale.gen</mark> - раскомментировать нужные локали и выполнить

`locale-gen`

### Дата

`timedatectl set-timezone Asia/Almaty`

### Загрузчик

#### Ставим grub2

`pacman -S grub2 efibootmgr`

`grub-install /dev/sda`

`grub-mkconfig -o /boot/grub/grub.cfg`

#### Или systemd-boot

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

`UUID` для диска `sda2` можно посмотреть так:

`lsblk -o NAME,UUID | grep -i sda2 | awk '{print $2}'`

Делаем пароль root

`passwd`

### Сеть для установленной системы

`systemctl enable NetworkManager.service`

### Завершение установки

`exit` - выходим из `chroot`

`umount - a` - отмонтируем то, что отмонтируется.

`poweroff` - выключаем.

## Настройки в установленной системе

### Сеть

`nmtui`

### Пользователи

`useradd -m -g users -G wheel,video -s /bin/bash MYUSERNAME`

`passwd MYUSERNAME`

Отредактировать <mark>/etc/sudoers</mark> - раскомментировать `%wheel ALL=(ALL:ALL) ALL`

`pacman -S xdg-user-dirs`

`xdg-user-dirs-update` - прописывает в каталог пользователя стандартные директории. Внимание, если локаль русская, то и названия будут русские.

### YAY

`pacman -S --needed git base-devel`

`mkdir ~/git; cd git`

`git clone https://aur.archlinux.org/yay.git`

`cd yay`

`makepkg -si`

### XORG

`pacman -S xorg xorg-server xorg-apps mesa libva-intel-driver vulkan-intel`

`pacman -S xf86-input-synaptics xorg-xinit xterm xorg-xclock`

### Звук

#### PulseAudio

`pacman -S pulseaudio pulseaudio-bluetooth pavucontrol`

#### или Pipewire

`pacman -S pipewire pipewire-alsa gst-plugin-pipewire pipewire-pulse`

Из сессии **ПОЛЬЗОВАТЕЛЯ** включаем сервисы

`systemctl --user enable pipewire.service`

`systemctl --user enable pipewire-pulse.service`

#### Bluetooth

`pacman -S bluez bluez-utils blueman`

`systemctl enable bluetooth.service`

### Политики

`pacman -S gnome-keyring polkit-gnome seahorse`

### Разное

`yay -S ncdu p7zip mc engrampa geany`

`yay -S firefox firefox-i18n-ru openssh ttf-hack`

`yay -S dropbox`

`yay -S pacman-contrib` - всякие `pactree`, `paccache` 

`sudo systemctl enable paccache.timer` - для удаления кэша раз в неделю

### Делаем Swap

#### Файлом

`fallocate -l 8G /swapfile`

`chmod 600 /swapfile`

`mkswap /swapfile`

`swapon /swapfile`

Изменяем <mark>/etc/fstab</mark>

```

/swapfile    none    swap    defaults,discard    0    0

```

#### или с помощью zram-generator. По-умолчанию создается устройство размером в половину ОЗУ.

`pacman -S zram-generator`

Вставить в <mark>/etc/systemd/zram-generator.conf</mark>

```
[zram0]
# Остальные параметры гуглить.
```

Выполнить

`systemctl daemon-reload`

и стартовать

`systemctl start systemd-zram-setup@zram0.service`

Проверка работоспособности

`swapon --show`

### Монтирование NTFS драйвером ядра (возможно какая-то хрень)

`yay -S udisks2`

В качестве обходного пути добавьте следующую опцию в секции `[defaults]` в файле <mark>/etc/udisks2/mount_options.conf</mark>:

`ntfs_defaults=uid=$UID,gid=$GID,noatime,prealloc`

### Redshift (гамма экрана в зависимости от времени)

Вставить в <mark>/etc/geoclue/geoclue.conf</mark>

```
url=https://location.services.mozilla.com/v1/geolocate?key=geoclue
[redshift]
allowed=true
system=false
users=
```

### Красота в терминале

`bat` - цветная замена cat

`dfc` - цветная замена df

`lsd` - замена ls с цветами и иконками

`zoxide` - умный переход по местам, ранее посещенным с помощью cd

`fish` - замена для `bash`

### Настройка fish

Файл <mark>~/.config/fish/config.fish</mark>

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

### BSPWM

`yay -S bspwm sxhkd polybar dmenu dunst alacritty picom fastfetch btop tapper rofi`

### XFCE4

`yay -S xfce4 xfce4-goodies gvfs gvfs-smb network-manager-applet lightdm`

`yay -S mugshot`

### Lightdm autologin

Редактируем <mark>/etc/lightdm/lightdm.conf</mark>

```
[Seat:*]
autologin-user=USERNAME
```

`groupadd -r autologin`

`gpasswd -a USERNAME autologin`

`sudo systemctl enable lightdm`

### Видеокодеки

`yay -S gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly`

Аппаратное декодирование видео на Intel GPU.

`yay -S libva-intel-driver`

Для процессоров новее 8-го поколения:

`yay -S intel-media-driver`

### MPV

`yay -S mpv`

Создаем файл <mark>~/.config/mpv/mpv.conf</mark> и вписываем:

```
vo=gpu-next
hwdec=auto
profile=high-quality

autofit-larger=85%x85%
geometry=50%:50%
save-position-on-quit

volume=100
volume-max=150
```
