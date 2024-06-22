#!/bin/bash
# 一定要用 ubuntu16 cuda9.2 不然报错有你好受的
# 安装的时候一定要用xshell，然后打开xmanager，不然x11这关过不去
# CUDA_HOME 一定要手动在 setup.py 里面去/mydata/src/pytorch/setup.py 在 128行下一行设置 CUDA_HOME="/usr/local/cuda-9.2"；因为不知道怎么回事，一直把我的 CUDA_HOME 更改为 /usr/local/cuda-9.2/bin，然后就会导致 -I链接的库一直有误
# anaconda 要换成 https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh ; 它script里面的版本不行

sudo apt-get update
sudo chmod -R 777 /mydata

sudo apt-get install build-essential dkms
wget https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.2.148-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_9.2.148-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt-get update
sudo apt-get install cuda-9-2


echo 'export PATH=/usr/local/cuda-9.2:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-9.2/include:/usr/local/cuda-9.2/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
echo 'export CUDA_HOME=/usr/local/cuda-9.2' >> ~/.bashrc
source ~/.bashrc
# export CUDA_LIB_PATH=/usr/local/cuda-9.2/include
# nvcc -V
sudo apt-get install nvidia-375


cd /mydata
git clone https://github.com/eniac/MimicNet.git

# 

./MimicNet/run_0_setup.sh GPU # conda 安装不上的就用 pip install