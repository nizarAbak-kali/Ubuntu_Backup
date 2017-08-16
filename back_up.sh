#!/bin/bash


# from : askubuntu.com/questions/9135/how-to-backup-settings-and-list-of-installed-packages
# A quick way of backing up a list of programs is to run this:
BACK_UP_DIR=./back_up
PROFILE_BACK_UP_DIR="$BACK_UP_DIR/profile"
SOURCE_LIST_BACK_UP_DIR="$BACK_UP_DIR/list"
mkdir -p $PROFILE_BACK_UP_DIR
mkdir -p $SOURCE_LIST_BACK_UP_DIR


# backup source list and installed packages

dpkg --get-selections > $SOURCE_LIST_BACK_UP_DIR/Package.list
sudo cp -R /etc/apt/sources.list* $SOURCE_LIST_BACK_UP_DIR
sudo apt-key exportall > $SOURCE_LIST_BACK_UP_DIR/Repo.keys

# backup config files

HIDDEN_FILES=$(ls --recursive -d ~/.??*)

rsync --progress $HIDDEN_FILES $PROFILE_BACK_UP_DIR

tar czvf back_up.tar.gz $BACK_UP_DIR

python drive.py --push_backup back_up.tar.gz
