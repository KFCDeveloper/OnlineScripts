#!/bin/bash
# wget -O - https://raw.githubusercontent.com/KFCDeveloper/OnlineScripts/main/script_Sinan/social_network_setup_auto.sh | bash
# install conda
cd /mydata
find /mydata/miniconda3 -mindepth 1 -maxdepth 1 ! -name "envs" -exec rm -rf {} +  # remove all the files except for "envs"
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_24.1.2-0-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
# sudo wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
source ~/.bashrc
sudo chmod -R 777 /mydata/miniconda3
sudo chmod -R 777 /mydata
sudo chmod -R 777 ~/.conda/
# create new env and install package
conda create --name sinan python=3.8 -y
conda activate sinan

# install docker
sudo apt update
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce=5:19.03.15~3-0~ubuntu-bionic docker-ce-cli=5:19.03.15~3-0~ubuntu-bionic containerd.io docker-buildx-plugin docker-compose-plugin -y
# install docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# install docker compose
#
sudo apt-get install libssl-dev -y
sudo apt-get install libz-dev -y
sudo apt-get install luarocks -y
sudo luarocks install luasocket
# ** change docker location
# change the docker images savign path /etc/docker/daemon.json
# {"graph": "/mydata/docker-image/storage"}
sudo service docker stop
echo '{"graph": "/mydata/docker-image/storage"}' | sudo tee /etc/docker/daemon.json
sudo service docker start

# setup social network
cd /mydata
git clone https://github.com/delimitrou/DeathStarBench.git
cd DeathStarBench/socialNetwork/
sudo apt install dbus-x11 -y
sudo apt install gnupg2 pass -y
# setup docker swarm cluster
# Start docker containers on single machine with docker-compose || sudo docker-compose up -d
# Start docker containers on a machine cluster with docker swarm
### Manager Node
# https://juejin.cn/post/7264168916293238821
# init swarm
sudo docker swarm init --advertise-addr $(curl -s icanhazip.com)
### Slave Node
sudo docker swarm join --token SWMTKN-1-3e290ee10t87o8t74ijncaie0whbpuh2u3trej3u77l4utna28-6c6yo36aslqzkl6mi3lmqa4gi 128.105.144.47:2377