#!bin/sh

eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa_personal
ssh-add ~/.ssh/id_rsa_work

