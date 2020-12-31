# Artix Install
**Warning**: This is for personal use and some configurations could be different from system to system. I am using a EFI partition system and no swap.

## Flashing Artix .iso
1. [Download Artix ISO](https://artixlinux.org/download.php);
2. Create Live USB:
    1. Find USB Drive to flash the .iso:
        ```sh
        lsblk
        ```
    2. Make Live USB:
        ```sh    
        dd bs=4M if=/path/to/artixlinux.iso of=/dev/sdx status=progress && sync
        ```
    3. Boot from Live USB.

## Partitioning the Disk
1. Find disk to install:
    ```sh
    fdisk -l
    ```
2. Select disk to format and partition:
    ```sh
    fdisk /dev/sdx
    ```
3. Delete previous partitions using `d`;    
4. Partition disk using `n`:
    1. Create EFI partition. Size = `+1G`;
    2. Create Root partition. Size = `+30G`;
    3. Create Home partition. Size = remaining.
5. Write partitions using `w`.

## Create Filesystems
1. Create FAT32 filesystem for EFI partition: 
    ```sh
    mkfs.fat -F32 /dev/sdx1
    ```
2. Create EXT4 filesystem for Root partition:
    ```sh
    mkfs.ext4 /dev/sdx2
    ```
3. Create EXT4 filesystem for Home partition:
    ```sh
    mkfs.ext4 /dev/sdx3
    ```
    
## Mount partitions
1. Mount Root partition:
    ```sh
    mount /dev/sdx2 /mnt
    ```
2. Mount EFI partition:
    ```sh
    mount /dev/sdx1 /mnt/boot
    ```
3. Mount Root partition:
    ```sh
    mount /dev/sdx3 /mnt/home
    ```

## Install Operating System and base packages
```sh
basestrap /mnt base base-devel runit elogind-runit linux linux-firmware neovim git
```

## Configure Operating System
```sh
fstabgen -U /mnt >> /mnt/etc/fstab
```

## Chroot into Artix
```sh
artools-chroot /mnt
```

## Set Time Zone
```sh
ls /usr/share/zoneinfo/Brazil/East /etc/localtime
hwclock --systohc
```

## Create Locale
1. Uncomment the following lines from `/etc/locale.gen`:
    1. `en_US.UTF-8`;
    2. `en_US.ISO-8859-1`;
    3. `pt_BR.UTF-8`;
2. Generate Locales:
    ```sh
    locale-gen
    ```
3. Configure Locale:
    ```sh
    nvim /etc/locale.conf

    # Insert into the file:
    LANG=en_US.ISO-8859-1
    LANGUAGE="en_US"
    LC_CTYPE=pt_BR.UTF-8
    ```
## Install Network Manager
1. Install packages:
    ```sh
    pacman -S networkmanager networkmanager-runit
    ```
2. Start Network Manager service:
    ```sh
    ln -s /etc/runit/sv/NetworkManager/ /run/runit/service
    ```

## Create Hostname
```sh
nvim /etc/hostname

# Insert hostname into the file:
<HOSTNAME>
```

## Edit Hosts
```sh
nvim /etc/hosts

# Insert into the file:
127.0.0.1   localhost
::1         localhost
127.0.0.1   <HOSTNAME>.localdomain <HOSTNAME>
```

## Make the Operating System bootable
1. Install packages:
    ```sh
    pacman -S grub os-prober efibootmgr
    ```
2. Set up grub:
    ```sh
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    ``` 
3. Make grub config:
    ```sh
    grub-mkconfig -o /boot/grub/grub.cfg
    ```

## Set root password
```sh
passwd
```

## Create non-root user
1. Add user
    ```sh
    useradd -m <USERNAME>
    passwd <USERNAME>
    usermod -aG wheel,audio,video,optical,storage,kvm <USERNAME>
    ```
2. Install sudo
    ```sh
    pacman -S sudo
    ```
3. Uncomment `wheel` group from `sudoers`:
    ```sh
    EDITOR=nvim visudo
    ```
