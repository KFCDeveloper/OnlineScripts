#!/bin/bash
# Ubuntu 20.04


cd /mydata
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_24.1.2-0-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
sudo chmod -R 777 ~/.conda
sudo chmod -R  777 /mydata
source ~/.bashrc
# create new env and install package
conda create --name flash python=3.12.1 -y
conda activate flash
pip install gym==0.26.2 matplotlib==3.8.3 numpy==1.26.4 pandas==2.2.1 psutil==5.9.8 torch==2.2.1 tqdm==4.65.0 transformers==4.39.1 scikit-learn
pip install torchmetrics
# pip install matplotlib==3.6.0 numpy==1.23.3 pandas==1.5.0 scikit_learn==1.1.2 torch==1.12.1 torchmetrics==0.9.3 tqdm==4.64.1
