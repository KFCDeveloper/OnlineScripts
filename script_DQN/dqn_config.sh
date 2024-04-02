#!/bin/bash
## 
cd /mydata
sudo chmod -R  777 /mydata
sudo chmod -R  777 ~
# install nvidia-driver
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get install -y nvidia-driver-470

# install conda
cd /mydata
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_24.1.2-0-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
source ~/.bashrc
sudo chmod -R 777 ~/.conda/
sudo chmod -R  777 /mydata

# create new env and install package
conda create --name dqn python=3.8 -y
conda activate dqn
# install tensorflow 1 using cuda11. link from https://blog.csdn.net/qq_41204464/article/details/128389945
pip install nvidia-pyindex
pip install nvidia-tensorflow[horovod]
pip install nvidia-tensorboard==1.15
# **restart** 
# **todo** : to upload project from windows
cd deepqueuenet
sudo apt-get install unzip -y
wget https://www.dropbox.com/s/q56sx4hxe93n4g5/DeepQueueNet-dataset.zip
chmod 777 ./DeepQueueNet-dataset.zip
unzip DeepQueueNet-dataset.zip
cp -r "DeepQueueNet-synthetic data"/* ./
rm -r "DeepQueueNet-synthetic data"
rm DeepQueueNet-dataset.zip

# install packages
conda install pandas=1.1.5 scipy=1.10.1 seaborn=0.12.2 tqdm matplotlib=3.7.2 jupyter notebook -y
conda install anaconda::scikit-learn numba::numba