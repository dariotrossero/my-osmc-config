#!/bin/bash
sudo apt-get update; #update repository cache
sudo apt-get install -y mc htop python3-pip deluge git python-pip build-essential libssl-dev libffi-dev python-dev python-setuptools python-pip python-dev git libssl-dev libxslt1-dev libxslt1.1 libxml2-dev libxml2 libssl-dev libffi-dev build-essential deluged deluge-web deluge-console python-mako unzip cron minidlna samba samba-common-bin rbp-userland-dev-osmc libvncserver-dev libconfig++-dev python-wheel python-cffi python-cryptography


#SickChill
sudo git clone https://github.com/SickChill/SickChill.git /opt/sickrage
sudo chown -R osmc:osmc /opt/sickrage
sudo cp sickrage.service /lib/systemd/system
sudo systemctl enable sickrage.service


#Deluge
#https://pimylifeup.com/raspberry-pi-deluge/
deluged
sudo pkill -i deluged
echo "-- Deluge installation --"
read -p 'Username: ' uservar
read -sp 'Password: ' passvar
echo "$uservar:$passvar:10" >> ~/.config/deluge/auth
deluge-console "config -s allow_remote True"
deluged
deluge-web -f

sudo cp deluge*.service /lib/systemd/system
sudo systemctl enable deluge-web.service
sudo systemctl enable deluged.service

#VNC SERVER
#https://discourse.osmc.tv/t/howto-install-a-vnc-server-on-the-raspberry-pi/1517


#minidlna
sudo cp minidlna.conf /etc
sudo cp minidlna-systemd.service /lib/systemd/system
sudo systemctl enable minidlna-systemd.service

