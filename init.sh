sudo apt update
sudo apt upgrade
sudo apt-get install ubuntu-desktop
sudo apt install xrdp
sudo systemctl status xrdp
sudo adduser xrdp ssl-cert
sudo adduser jc
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt install ffmpeg obs-studio
sudo ufw allow from any to any port 3389 proto tcp
