#!/bin/bash

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

# no meta learner
python main.py --operation=train --model_dir=./model --data_path=../data-firm/asource.csv
# 这是flash的adaptation， checkpoint是pretrain model， data就是训练数据集
python meta_main.py --operation=adaptation --checkpoint_path=./model/flashSourceModel-ep200.pth.tar --data_path=../data-firm/writefile_writefile_output.csv 