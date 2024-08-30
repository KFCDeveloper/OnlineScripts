#!/bin/bash
## ubuntu 20.04 !!!!!
cd /mydata
sudo chmod -R  777 /mydata
# sudo chmod -R  777 ~/.co
# install nvidia-driver
# sudo apt-get install alsa-utils -y  # 安装了这个，下面 driver-560 就不报错了; 也可能是之前用的apt-get 然后改成了 apt
# sudo add-apt-repository -y ppa:graphics-drivers/ppa
# sudo apt install ubuntu-drivers-common -y
# ubuntu-drivers devices
# sudo apt install nvidia-driver-470   # nvidia-driver-560  nvidia-driver-470

# !!!! expand `/`
sudo fdisk /dev/sda
# `d` delete  /dev/sda1 partition, and `n` create a partition; remove the signature?  no 
# `w` to save 
# reboot this machine 
sudo resize2fs /dev/sda1


# cuda 11.04
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.4.0/local_installers/cuda-repo-ubuntu2004-11-4-local_11.4.0-470.42.01-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-11-4-local_11.4.0-470.42.01-1_amd64.deb
sudo apt-key add /var/cuda-repo-ubuntu2004-11-4-local/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda


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
conda create --name astraea python=3.8 -y
conda activate astraea

# redirect to /mydata/tmp https://blog.csdn.net/qq_42650571/article/details/109635145
mkdir /mydata/tmp
vim ~/.bashrc
# add `export TMPDIR=/mydata/tmp`
source ~/.bashrc
conda activate astraea

# install tensorflow 1 using cuda11. link from https://blog.csdn.net/qq_41204464/article/details/128389945
pip install nvidia-pyindex
pip install nvidia-tensorflow[horovod]==1.15.5+nv22.07 #21.8
pip install nvidia-tensorboard==1.15
pip install numpy==1.23.5
pip install pandas scipy seaborn matplotlib tqdm numba scikit-learn

# **restart** 
# **todo** : to upload project from windows

# download or transfer astraea-open-source
cd /mydata/astraea-open-source

## Install the kernel
sudo apt install ./kernel/deb/linux-headers-5.4.73-learner_5.4.73-learner-1_amd64.deb
sudo apt install ./kernel/deb/linux-image-5.4.73-learner_5.4.73-learner-1_amd64.deb

# cd src
# mkdir build && cd build
# sudo apt install cmake-mozilla
# CXX=/usr/bin/g++-9 cmake ..
# make -j



./install_tensorflow_cc.sh  # note: change CRLF to LF


cd /mydata/astraea-open-source/third_party/
git clone https://github.com/nlohmann/json.git

cd /mydata/astraea-open-source/src/
mkdir build && cd build
# CXX=/usr/bin/g++-9 cmake .. -DCOMPILE_INFERENCE_SERVICE=ON
CXX=/usr/bin/g++-9 cmake ..
make -j

# run
/build/bin/server --port=12345
# run
/mydata/astraea-open-source/src/build/bin/server --port=12345
/mydata/astraea-open-source/src/build/bin/client_eval --ip=127.0.0.1 --port=12345 --cong=astraea --interval=30 --pyhelper=./python/infer.py --model=./models/py/



# tensorflow_cc  https://github.com/FloopCZ/tensorflow_cc/tree/v1.15.0
cd /mydata/tensorflow_cc
git clone https://github.com/FloopCZ/tensorflow_cc.git
cd /mydata/tensorflow_cc/tensorflow_cc
mkdir build && cd build
cd /mydata/tensorflow_cc/tensorflow_cc/build
cmake ..
make && sudo make install

# install Bazel https://bazel.build/install/ubuntu
sudo apt install apt-transport-https curl gnupg -y
curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg
sudo mv bazel-archive-keyring.gpg /usr/share/keyrings
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list

sudo apt update
sudo apt install bazel-5.4.0

sudo ln -s /usr/bin/bazel-5.4.0 /usr/bin/bazel



# install packages
pip install numpy==1.23.5
# conda install pandas=1.1.5 scipy=1.10.1 seaborn=0.12.2 tqdm matplotlib=3.7.2 jupyter notebook -y
# conda install anaconda::scikit-learn numba::numba
pip install pandas scipy seaborn matplotlib tqdm numba scikit-learn
