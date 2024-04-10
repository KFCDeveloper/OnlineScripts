#!/bin/bash
# wget -O - https://raw.githubusercontent.com/KFCDeveloper/OnlineScripts/main/script_for_FIRM/new_script/base_setup.sh | bash
# install conda
cd /mydata
find /mydata/miniconda3 -mindepth 1 -maxdepth 1 ! -name "envs" -exec rm -rf {} +  # remove all the files except for "envs"
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_24.1.2-0-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
source ~/.bashrc
sudo chmod -R 777 /mydata/miniconda3
sudo chmod -R 777 /mydata
sudo chmod -R 777 ~/.conda/
# create new env and install package
/mydata/miniconda3/condabin/conda create --name firm python=3.7 -y
# conda activate firm

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

# you must install 
# sudo apt-get install docker-ce=5:19.03.15~3-0~ubuntu-bionic docker-ce-cli=5:19.03.15~3-0~ubuntu-bionic containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo apt-get install docker-ce=5:19.03.5~3-0~ubuntu-$(lsb_release -cs) docker-ce-cli=5:19.03.5~3-0~ubuntu-$(lsb_release -cs) containerd.io -y
# install docker compose
# sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.17.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# install docker compose
#
sudo apt-get install libssl-dev -y
sudo apt-get install libz-dev -y
sudo apt-get install luarocks -y
sudo luarocks install luasocket -y
# ** change docker location
# change the docker images savign path /etc/docker/daemon.json
# {"graph": "/mydata/docker-image/storage"}
sudo service docker stop
echo '{"graph": "/mydata/docker-image/storage"}' | sudo tee /etc/docker/daemon.json
sudo service docker start
# Start and Enable Docker
# sudo systemctl enable docker
# sudo systemctl start docker
# Install Kubernetes
sudo swapoff -a
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
# curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.25/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.25/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
# dpkg -i http://mirrors.aliyun.com/kubernetes/apt/pool/kubeadm_1.17.3-00_amd64_a993cfe07313b10cb69c3d0a680fdc0f6f3976e226d5fe3d062be0cea265274c.deb
# dpkg -i http://mirrors.aliyun.com/kubernetes/apt/pool/kubelet_1.17.3-00_amd64_f0b930ce4160af585fb10dc8e4f76747a60f04b6343c45405afbe79d380ae41f.deb
# dpkg -i http://mirrors.aliyun.com/kubernetes/apt/pool/kubectl_1.17.3-00_amd64_289913506f67535270a8ab4d9b30e6ece825440bc00a225295915741946c7bc6.deb

sudo apt install -y kubeadm=1.17.3-00 kubelet=1.17.3-00 kubectl=1.17.3-00
# sudo apt install -y kubeadm=1.25.1-1.1 kubelet=1.25.1-1.1 kubectl=1.25.1-1.1
kubeadm version
# sudo apt remove kubeadm kubelet kubectl
sudo rm -rf /etc/containerd/config.toml
sudo systemctl restart containerd