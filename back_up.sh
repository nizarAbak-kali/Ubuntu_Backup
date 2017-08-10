#!/bin/bash


# from : askubuntu.com/questions/9135/how-to-backup-settings-and-list-of-installed-packages
# A quick way of backing up a list of programs is to run this:
BACK_UP_DIR=~/back_up

mkdir -p $BACK_UP_DIR/profile
cd $BACK_UP_DIR

# backup source list and installed packages

dpkg --get-selections > Package.list
sudo cp -R /etc/apt/sources.list* .
sudo apt-key exportall > Repo.keys

# backup config files 

rsync --progress /home/`whoami` profile

