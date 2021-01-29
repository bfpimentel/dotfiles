#!bin/sh

# ssh agent setup
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa_personal
ssh-add ~/.ssh/id_rsa_work

# displays setup
#sh $HOME/.config/screenlayout/dual-monitors-horizontal.sh

# kb layout setup
setxkbmap -layout us -variant intl

# wm setup
nitrogen --restore &
picom --experimental-backends &
flameshot &
dunst &
