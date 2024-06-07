#!/bin/bash

# https://github.com/godka/Pensieve-PPO/tree/torch
cd /mydata
sudo chmod -R  777 /mydata
sudo apt update
# install cuda
sudo apt-get install --reinstall libc6-i386 -y
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt install ubuntu-drivers-common -y
ubuntu-drivers devices
sudo apt-get install -y nvidia-driver-535       # 535   nvidia-driver-470 # use ubuntu22 18 ,not 20, it has some bugs

# install conda
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_24.1.2-0-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
sudo chmod -R 777 ~/.conda
sudo chmod -R  777 /mydata
source ~/.bashrc
# create new env and install package
conda create --name casual_sim_abr python=3.8 -y