#!/bin/bash

sudo chmod -R  777 /mydata
cd /mydata

git clone https://github.com/ss7krd/Usher.git

cd /mydata
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_24.1.2-0-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
source ~/.bashrc
# create new env and install package
conda create --name usher python=3.8 -y
conda activate usher
cd /mydata/Usher/myfiles/requirements_gen
pip install -r requirements.txt
pip install tensorflow-gpu==2.4.1 pandas seaborn scikit-learn face-recognition

python-flatbuffers  sqlite  tk  xz  zlib   mkl_fft  scipy tensorflow-base  cudatoolkit  cudnn