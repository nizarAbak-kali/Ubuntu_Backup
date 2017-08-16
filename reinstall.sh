#!/bin/bash

# Reinstall shell to reinstall a session's config from a backup
# from : askubuntu.com/questions/9135/how-to-backup-settings-and-list-of-installed-packages


python drive.py --pull_backup

tar xzvf back_up.tar.gz

BACK_UP_DIR=./back_up/back_up
BACK_UP_DIR_PROFILE=$BACK_UP_DIR/profile
BACK_UP_DIR_PACKAKE=$BACK_UP_DIR/packages

rsync --progress  $BACK_UP_DIR_PROFILE  /home/`whoami`

sudo apt-key add $BACK_UP_DIR_PACKAKE/Repo.keys
sudo cp -R  $BACK_UP_DIR_PACKAKE/sources.list* /etc/apt/
sudo apt-get update
sudo apt-get install dselect
sudo dselect update

# You may have to update dpkg's list of available packages or it will just ignore your selections 
# (see this debian bug for more info). You should do this before sudo dpkg --set-selections < ~/Package.list, like this:
# apt-cache dumpavail > ~/temp_avail
# sudo dpkg --merge-avail ~/temp_avail
# rm ~/temp_avail

sudo dpkg --set-selections < P $BACK_UP_DIR_PACKAKE/Package.list
sudo apt-get dselect-upgrade -y

