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
pip install tensorboard torch==1.11.0+cu113 torchvision==0.12.0+cu113 torchaudio==0.11.0 --extra-index-url https://download.pytorch.org/whl/cu113

# clone project
cd /mydata
git clone https://github.com/CausalSim/Unbiased-Trace-Driven-Simulation.git

# prepare dataset
# ** ** 

# train SLSim
python training/sl_subset_train.py --dir CAUSALSIM_DIR --left_out_policy linear_bba  # python training/sl_subset_train.py --dir CAUSALSIM_DIR --left_out_policy target 
# train CasualSim
python training/train_subset.py --dir CAUSALSIM_DIR --left_out_policy linear_bba --C 0.05 

# Counterfactual Simulation
python inference/extract_subset_latents.py --dir CAUSALSIM_DIR --left_out_policy linear_bba --C 0.05 #  Using CausalSim to extract and save the latent factors
python inference/expert_cfs.py --dir CAUSALSIM_DIR # ExpertSim
python inference/sl_subset_cfs.py --dir CAUSALSIM_DIR --left_out_policy linear_bba # SLSim 
