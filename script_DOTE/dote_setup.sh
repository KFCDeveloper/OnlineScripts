#!/bin/bash

# https://github.com/PredWanTE/DOTE/tree/main?tab=readme-ov-file
sudo apt-get install tmux
tmux new -s dote

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
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
source ~/.bashrc

# **todo** : to upload project from windows
git clone https://github.com/PredWanTE/DOTE.git
# install gurobi
mkdir -p /mydata/software
cd /mydata/software
wget https://packages.gurobi.com/9.1/gurobi9.1.0_linux64.tar.gz
tar xvfz gurobi9.1.0_linux64.tar.gz
# add .bashrc  ** sudo vim ~/.bashrc **
sudo vim ~/.bashrc
# export GUROBI_HOME="/mydata/software/gurobi910/linux64"
# export PATH="${PATH}:${GUROBI_HOME}/bin"
# export LD_LIBRARY_PATH="${GUROBI_HOME}/lib"
# export GRB_LICENSE_FILE="/users/DylanYu/gurobi.lic"
# export PYTHONPATH="/mydata/DOTE/networking_envs:/mydata/DOTE/openai_baselines"
source ~/.bashrc
grbgetkey xxxxxx # https://portal.gurobi.com/iam/licenses/request/?type=academic
# ** BASE_PATH_LOCAL = "/mydata/DOTE/networking_envs" **

# create new env and install package
conda create --name dote python=3.8 -y
conda activate dote
cd /mydata/DOTE
pip install torch==1.11.0+cu113 torchvision==0.12.0+cu113 torchaudio==0.11.0 --extra-index-url https://download.pytorch.org/whl/cu113
conda install scikit-learn numpy=1.19.5 scipy conda-forge::gym joblib dill progressbar2 mpi4py networkx tqdm keras pandas=1.1 statsmodels anaconda::tensorflow-gpu matplotlib
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt update
sudo apt install gcc-9
sudo apt install libstdc++6

#** use GEANT dataset **
mkdir -p /mydata/software/GEANT
cd /mydata/software/GEANT
wget http://sndlib.zib.de/download/directed-geant-uhlig-15min-over-4months-ALL-native.tgz
tar -xzvf directed-geant-uhlig-15min-over-4months-ALL-native.tgz directed-geant-uhlig-15min-over-4months-ALL-native/
#** modify DOTE/networking_envs/data/gen_geant_topo.py **
# Run gen_geant_topo.py
python3 /mydata/DOTE/networking_envs/data/gen_geant_topo.py
# ** **
mv GEANT /mydata/DOTE/networking_envs/data/
cd /mydata/DOTE/networking_envs/data/GEANT
python3 /mydata/DOTE/networking_envs/data/compute_opts.py

#** use Topology Zoo Abilene dataset**
cd /mydata/DOTE/networking_envs/data/
mkdir -p /mydata/DOTE/networking_envs/data/zoo_topologies
wget http://www.topology-zoo.org/files/Abilene.gml
# /networking_envs/data/gml_to_dote.py, set the src_dir, dest_dir and network_name variables.
python3 gml_to_dote.py
# don't forget!! To compute the optimum for the demand matrices, go to /mydata/DOTE/networking_envs/data/Abilene and run /mydata/DOTE/networking_envs/data/compute_opts.py

# install java8
sudo apt-get update
sudo apt install openjdk-8-jdk
# ** **