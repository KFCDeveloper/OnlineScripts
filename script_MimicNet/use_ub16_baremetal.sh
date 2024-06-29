#!/bin/bash


sudo apt-get update
sudo chmod -R 777 /mydata

cd /mydata
sudo apt-get install build-essential dkms -y
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
# sudo apt-get install nvidia-375

# 安装 cudann 不然第二部 compile 会报错
cd /mydata
wget https://developer.download.nvidia.cn/compute/redist/cudnn/v7.6.5/cudnn-9.2-linux-x64-v7.6.5.32.tgz
tar -xzvf cudnn-9.2-linux-x64-v7.6.5.32.tgz
sudo cp cuda/include/cudnn.h /usr/local/cuda-9.2/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda-9.2/lib64
sudo chmod a+r /usr/local/cuda-9.2/include/cudnn.h /usr/local/cuda-9.2/lib64/libcudnn*




cd /mydata
git clone https://github.com/eniac/MimicNet.git

# run_0_setup.py
# 一定要用 ubuntu16 cuda9.2 不然报错有你好受的
# 安装的时候一定要用xshell，然后打开xmanager，不然x11这关过不去
#! /mydata/MimicNet/run_0_setup.sh中的95行；Anaconda 要换成 https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh ; 它script里面的版本不行；；然后下面的 各个 Anaconda 文件修改成 Anaconda3-2020.02-Linux-x86_64.sh
#! 94行加上 sudo   sudo ./Anaconda3-2020.02-Linux-x86_64.sh -b -p ${BASE_DIR}/opt/anaconda3
#! conda install 换成 pip install

# CUDA_HOME 一定要手动在 setup.py 里面去/mydata/src/pytorch/setup.py 在 128行下一行设置 CUDA_HOME="/usr/local/cuda-9.2"；因为不知道怎么回事，一直把我的 CUDA_HOME 更改为 /usr/local/cuda-9.2/bin，然后就会导致 -I链接的库一直有误 #! 但是我发现有的时候又不需要这一行，每次安装都不一样，很离谱


./MimicNet/run_0_setup.sh GPU # conda 安装不上的就用 pip install
source /etc/profile.d/mimicnet.sh


cp -r /mydata/src/pytorch/torch/lib/tmp_install/include/THCUNN /mydata/opt/include
cp -r /mydata/src/pytorch/torch/lib/tmp_install/include/THC /mydata/opt/include

cd MimicNet/
# ./run_1_compile.sh GPU # 不过我发现他代码里的 run_all.sh 也没有在 compile的时候指定用GPU，并且在训练的时候 GPU是起效了的，所以我就没在意了
./run_1_compile.sh CPU # GPU编译不成功，因为只有libATen_cpu.so这个库，但是run_0的代码只能编译出这个，不知原因，需要libATen_cuda.so

./run_all.sh tcp GPU
# 
./run_all.sh tcp 2 GPU 
# ./run_2_generate.sh tcp GPU