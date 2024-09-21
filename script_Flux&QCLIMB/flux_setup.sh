#!/bin/bash

# https://github.com/ShreyaChak15/flow-prediction  这个人fork了原库，并且有readme，不知道怎么回事，原库是没有readme的
sudo chmod  -R 777 /mydata
cd /mydata
# install git-lfs and download data
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
git lfs install

git clone https://github.com/vojislavdjukic/flux.git
# install conda
cd /mydata
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_24.1.2-0-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
source ~/.bashrc
# create new env and install package
conda create --name flux python=3.8 -y
conda activate flux

pip install scikit-learn matplotlib pandas xgboost keras tensorflow

cd /mydata/flux/ml/
python ffnn.py



