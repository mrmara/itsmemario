elevate_privilege () {
    #gain root privileges through sudo
    #if root cannot gain cannot continue
    echo "ELEVATE PRIVILEGE"
    if [ $UID -ne 0 ]
    then
        echo -e "${YELLOW}Hi, this tool requires root privileges"
        echo -e "The script might request to insert your user password in order to use sudo${NC}"
        sudo cat /dev/null
        if [ $? -eq 0 ]
        then
            echo -e "Thnx, now we can continue with the process!!!\n"
        else
            echo -e "${RED}Ops, I'm sorry but the passowrd is wrong or sudo is not properly configured!!!\n${NC}"
            exit 1
        fi
    fi
}
elevate_privilege
echo "Installing prerequisites..."
sudo apt update && sudo apt install sox && sudo apt-get install libsox-fmt-all
echo "...done"
# create the directory for the game if it does noe exists
echo "Creating directory /home/$USER/.super_mario_bros"
mkdir -p /home/$USER/.super_mario_bros
echo "...done"
# copy the game files to the directory
echo "installing files..."
cp -r supermario_sound.mp3 /home/$USER/.super_mario_bros
cp -r supermario.alias /home/$USER/.super_mario_bros
echo "...done"
echo "adding source alias in .bashrc..."
if grep -qF "source /home/$USER/.super_mario_bros/supermario.alias" "/home/$USER/.bashrc"; then
    echo "Alias already present in bashrc file"
else
    echo "source /home/$USER/.super_mario_bros/supermario.alias" >> /home/$USER/.bashrc
fi
echo "...done"
echo "Adding sudoers entry..."
sudo cp /etc/sudoers .
sudo chmod 777 sudoers
if grep -qF "$USER ALL=(ALL) NOPASSWD: /sbin/poweroff, /sbin/reboot, /sbin/shutdown, /bin/strace" "sudoers"; then
    echo "Sudoers entry already present in sudoers file"
else
    echo "$USER ALL=(ALL) NOPASSWD: /sbin/poweroff, /sbin/reboot, /sbin/shutdown, /bin/strace" >> sudoers
fi
sudo chmod 555 sudoers
sudo mv sudoers /etc/sudoers
echo "...done"
