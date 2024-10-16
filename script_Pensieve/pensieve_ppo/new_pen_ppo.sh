#!/bin/bash

# https://github.com/godka/Pensieve-PPO/tree/torch

sudo chmod -R  777 /mydata
sudo apt update
cd /mydata

# cuda 11.04 using ubuntu20.04
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

# git clone
git clone https://github.com/KFCDeveloper/ML4SysReproduceProjects.git
cd ML4SysReproduceProjects
git checkout -t origin/Pensieve-PPO
cd ..
mv ML4SysReproduceProjects Pensieve-PPO


cd /mydata/Pensieve-PPO/src
# python train_less_features.py
# 现在不需要 less feature了，全 feature是可以不报错的; 将之前的 `S_INFO = 4` 修改为 `S_INFO = 6`
python train.py

# ------ tensorboard
cd /mydata/Pensieve-PPO/src
tensorboard --logdir=./
# ------ install tensorboard extension in vscode
# Based on the turning point, you can determine an optimal time to terminate RL training.

# 解析一下这个 `train_less_features.py`, tensorboard 是 train 的时候把东西写到 ppo 文件夹，然后每个 epoch 会进行 testing 东西写到 test_results
# --- install cupy; 
conda activate pensieve_ppo
pip install cupy-cuda114 scikit-learn