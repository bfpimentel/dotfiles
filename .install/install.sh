#!/bin/bash

pacman -S \
    alacritty \
    arandr \
    autoconfg \
    automake \
    avrdude \
    clang \
    code \
    dfu-programmer \
    dfu-util \
    discord \
    docker \
    docker-compose \
    fakeroot \
    firefox \
    flameshot \
    gcc \
    git \
    grub \
    jdk8-openjdk \
    kitty \
    make \
    mesa \
    neofetch \
    networkmanager \
    nitrogen \
    noto-fonts-emoji \
    openssh \
    pavucontrol \
    picom \
    pulseaudio \
    pulseaudio-alsa \
    python-pip \
    qmk \
    qtile \
    rofi \
    sudo \
    thunar \
    vulkan-radeon \
    unzip \
    xf86-video-amdgpu \
    xf86-video-vesa \
    xorg-server \
    zip \
    zsh

git clone https://aur.archlinux.org/yay.git $HOME/.yay &&
    cd yay &&
    makepkg -si

cd $HOME

yay -S \
    android-studio \
    rofi-dmenu \
    slack-desktop \
    spotify \

git clone --bare --recurse-submodules -j8 https://github.com/bfpimentel/dotfiles.git $HOME/.config

alias config='/usr/bin/git --git-dir=$HOME/.config/ --work-tree=$HOME'

config checkout 
