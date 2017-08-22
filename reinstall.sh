#!/bin/bash -x

# Reinstall shell to reinstall a session's config from a backup
# from : askubuntu.com/questions/9135/how-to-backup-settings-and-list-of-installed-packages

echo "****************************************GETTING ONLINE BACKUP"
python drive.py --pull_backup

echo "****************************************EXTRACTING BACKUP"
tar xzvf back_up.tar.gz

BACK_UP_DIR=./back_up
BACK_UP_DIR_PROFILE=$BACK_UP_DIR/profile
BACK_UP_DIR_PACKAKE=$BACK_UP_DIR/list

echo $BACK_UP_DIR
echo $BACK_UP_DIR_PROFILE
echo $BACK_UP_DIR_PACKAKE


shopt -s dotglob


echo "****************************************sync profiles..."
sudo rsync -avr --progress  $BACK_UP_DIR_PROFILE  /home/`whoami`


echo "****************************************copy key ..."
sudo apt-key add $BACK_UP_DIR_PACKAKE/Repo.keys
echo "****************************************copy sources "
sudo cp -R  $BACK_UP_DIR_PACKAKE/sources.list* /etc/apt/
echo "**************************************** UPDATE"
sudo apt-get update
echo "**************************************** DSELECT"
sudo apt-get install dselect
sudo dselect update

# You may have to update dpkg's list of available packages or it will just ignore your selections 
# (see this debian bug for more info). You should do this before sudo dpkg --set-selections < ~/Package.list, like this:
# apt-cache dumpavail > ~/temp_avail
# sudo dpkg --merge-avail ~/temp_avail
# rm ~/temp_avail

echo "****************************************DPKG SET SELECTION"
sudo dpkg --set-selections < $BACK_UP_DIR_PACKAKE/Package.list
sudo apt-get dselect-upgrade -y --allow-unauthenticated

