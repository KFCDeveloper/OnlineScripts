#!/bin/bash
## master node
cd /mydata
sudo chmod -R  777 /mydata

# install nvidia-driver
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get install -y nvidia-driver-470

# install conda
cd /mydata
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
source ~/.bashrc

# create new env and install package
conda create --name dqn python=3.8 -y
conda activate dqn
# install tensorflow 1 using cuda11. link from https://blog.csdn.net/qq_41204464/article/details/128389945
pip install nvidia-pyindex
pip install nvidia-tensorflow[horovod]
pip install nvidia-tensorboard==1.15

conda install numpy pandas tqdm matplotlib scikit-learn pytorch torchvision python-wget torchaudio -y