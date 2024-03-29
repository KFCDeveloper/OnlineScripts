#!/bin/bash

# https://github.com/PredWanTE/DOTE/tree/main?tab=readme-ov-file
sudo apt-get update
sudo apt-get install tmux
tmux new -s dote

cd /mydata
sudo chmod -R  777 /mydata
# sudo chmod -R  777 ~

# install nvidia-driver
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt install ubuntu-drivers-common -y
ubuntu-drivers devices
sudo apt-get install -y nvidia-driver-470



# **todo** : to upload project from windows
# git clone https://github.com/PredWanTE/DOTE.git
git clone https://github.com/KFCDeveloper/ML4SysReproduceProjects.git
mv ML4SysReproduceProjects DOTE
cd DOTE
git checkout -t origin/DOTE
# upload through ssh from another server
ssh-keygen -t rsa -b 2048
cat ~/.ssh/id_rsa.pub
# another sever: 
sudo vim ~/.ssh/authorized_keys # copy the pub key to another server
rsync -avz --progress -e ssh  /mydata/DOTE DylanYu@c240g5-110107.wisc.cloudlab.us:/mydata/


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
# on tfgirl
# export GUROBI_HOME="/data/ydy/software/gurobi910/linux64"
# export PATH="${PATH}:${GUROBI_HOME}/bin"
# export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${GUROBI_HOME}/lib"
# export GRB_LICENSE_FILE="/home/amax/gurobi.lic"
source ~/.bashrc # !!!
grbgetkey xxxxxx # https://portal.gurobi.com/iam/licenses/request/?type=academic
# ** BASE_PATH_LOCAL = "/mydata/DOTE/networking_envs" **

# install conda
cd /mydata
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
source ~/.bashrc
# create new env and install package
conda create --name dote python=3.8 -y
conda activate dote
cd /mydata/DOTE
pip install torch==1.11.0+cu113 torchvision==0.12.0+cu113 torchaudio==0.11.0 --extra-index-url https://download.pytorch.org/whl/cu113
conda install scikit-learn numpy=1.19.5 scipy conda-forge::gym joblib dill progressbar2 mpi4py networkx=2.8.8 tqdm keras pandas=1.1 statsmodels anaconda::tensorflow-gpu matplotlib
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt update
sudo apt install gcc-9 -y
sudo apt install libstdc++6 -y

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
cd /mydata/DOTE/networking_envs/data/Abilene-squeeze-links
python3 /mydata/DOTE/networking_envs/data/compute_opts.py


# install java8
sudo apt-get update
sudo apt install openjdk-8-jdk -y
# ** **

# DOTE training execution code
# python3 /mydata/DOTE/dote.py --ecmp_topo Abilene --paths_from sp --so_mode train --so_epochs 50 --so_batch_size 200 --opt_function MAXFLOW
python3 /mydata/DOTE/dote.py --ecmp_topo Abilene-0.25 --paths_from sp --so_mode train --so_epochs 20 --so_batch_size 32 --opt_function MAXUTIL
# test
python3 /mydata/DOTE/dote.py --ecmp_topo Abilene-2-somebw --paths_from sp --so_mode test --so_epochs 20 --so_batch_size 32 --opt_function MAXUTIL

# DOTE predict execution code
# train: why first run this, than the latter; I find 1.processing training data 2.start training ;
python3 ml/sl_algos/evaluate.py --ecmp_topo Abilene-half --paths_from sp --sl_model_type linear_regression --sl_type stats_comm --opt_function MAXUTIL
# eval
python3 ml/sl_algos/evaluate.py --ecmp_topo Abilene-half --paths_from sp --sl_model_type linear_regression --sl_type eval --opt_function MAXUTIL



## Half bandwidth
# modify gml_to_dote.py, line 126, add ``* 0.5``