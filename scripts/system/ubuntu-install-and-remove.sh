echo ""
echo -n "You're about to update the system and uninstall useless packages and install required utils. Break to cancel..."
read aaa

sudo apt update && sudo apt upgrade -y
sudo apt remove  -y unattended-upgrades libreoffice* thunderbir* remmina rhythmbox shotwell* transmission-* totem* simple-scan
sudo apt remove  -y aisleriot gnome-sudoku gnome-mahjongg gnome-mines
sudo apt install -y openssh-server samba cifs-utils p7zip-full
sudo apt autoremove -y
