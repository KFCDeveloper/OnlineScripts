#!/bin/bash

cd /mydata
sudo chmod -R  777 /mydata
# install cuda
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt install ubuntu-drivers-common
sudo apt-get install -y nvidia-driver-470

# install conda
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
source ~/.bashrc
# create new env and install package
conda create --name casual_sim_abr python=3.8 -y
conda activate casual_sim_abr
conda install numpy pandas tqdm matplotlib scikit-learn pytorch torchvision python-wget torchaudio -y

# clone project
cd /mydata
git clone https://github.com/CausalSim/Unbiased-Trace-Driven-Simulation.git

