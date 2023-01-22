sudo apt-get update
sudo apt-get install docker.io

sudo systemctl enable docker
systemctl status docker

sudo  ip link add name docker0 type bridge
sudo ip addr add dev docker0 172.17.0.1/16

sudo systemctl stop docker
sudo systemctl start docker
sudo systemctl enable docker

