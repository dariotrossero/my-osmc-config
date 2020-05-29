#!/bin/bash
echo "Installing packages...."
sudo apt-get update; #update repository cache
sudo apt-get install -y mc htop python3-pip deluge git python-pip build-essential libssl-dev libffi-dev python-dev python-setuptools python-pip python-dev git libssl-dev libxslt1-dev libxslt1.1 libxml2-dev libxml2 libssl-dev libffi-dev build-essential deluged deluge-web deluge-console python-mako unzip cron minidlna samba samba-common-bin rbp-userland-dev-osmc libvncserver-dev libconfig++-dev python-wheel python-cffi python-cryptography python-setuptools python3-setuptools gunicorn3


echo "Installing SickRage...."
#SickChill
sudo git clone https://github.com/SickChill/SickChill.git /opt/sickrage
sudo chown -R osmc:osmc /opt/sickrage
sudo cp sickrage.service /lib/systemd/system
sudo systemctl enable sickrage.service


echo "Installing Deluge...."
#Deluge
#https://pimylifeup.com/raspberry-pi-deluge/
deluged
sudo pkill -i deluged
echo "Access to <ip>:9112 with password 'deluge'"
deluge-console "config -s allow_remote True"
deluged
deluge-web -f

sudo cp deluge*.service /lib/systemd/system
sudo systemctl enable deluge-web.service
sudo systemctl enable deluged.service

#VNC SERVER
#https://discourse.osmc.tv/t/howto-install-a-vnc-server-on-the-raspberry-pi/1517

echo "Installing Minidlna...."
#minidlna
sudo cp minidlna.conf /etc
sudo cp minidlna-systemd.service /lib/systemd/system
sudo systemctl enable minidlna-systemd.service


#piwheels
sudo mv pip.conf /etc

echo "Other stuff"
mkdir ~/bin
git clone https://gitlab.com/dariotrossero/coopeofertas.git ~/bin
pip3 install -r ~/bin/coopeofertas/back/requirements.txt
pip3 install -r ~/bin/coopeofertas/web/requirements.txt


echo "Configuring Samba..."
mv smb.conf /etc/samba
sudo systemctl unmask samba.service
sudo systemctl enable smbd.service nmbd.service
sudo systemctl start smbd.service nmbd.service

echo "Setting crontab jobs"
(crontab -l 2>/dev/null; echo "55 08 * * * rm /home/osmc/bin/coopeofertas/back/offers/*") | crontab -
(crontab -l 2>/dev/null; echo "00 09 * * * cd /home/osmc/bin/coopeofertas/back/; ./main.py c") | crontab -
(crontab -l 2>/dev/null; echo "10 09 * * * cd /home/osmc/bin/coopeofertas/back/; ./main.py v") | crontab -
(crontab -l 2>/dev/null; echo "20 09 * * * cd /home/osmc/bin/coopeofertas/back/; ./main.py w") | crontab -
(crontab -l 2>/dev/null; echo "00 02 * * * /home/osmc/bin/reaname_extensions.sh") | crontab -
