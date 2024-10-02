#!/bin/bash

# https://github.com/godka/Pensieve-PPO/tree/torch

sudo chmod -R  777 /mydata
sudo apt update
cd /mydata

# cuda 11.04
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.4.0/local_installers/cuda-repo-ubuntu2004-11-4-local_11.4.0-470.42.01-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-11-4-local_11.4.0-470.42.01-1_amd64.deb
sudo apt-key add /var/cuda-repo-ubuntu2004-11-4-local/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda


# install conda
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_24.1.2-0-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
sudo chmod -R 777 ~/.conda
sudo chmod -R  777 /mydata
source ~/.bashrc
# create new env and install package
conda create --name pensieve_ppo python=3.9 -y
conda activate pensieve_ppo
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
pip3 install matplotlib scipy tensorboard

# 
git clone https://github.com/KFCDeveloper/ML4SysReproduceProjects.git
cd ML4SysReproduceProjects
git checkout -t origin/Pensieve-PPO
cd ..
mv ML4SysReproduceProjects Pensieve-PPO