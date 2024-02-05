#!/bin/bash

cd /mydata
sudo chmod -R  777 /mydata
# install cuda
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt install ubuntu-drivers-common -y
ubuntu-drivers devices
sudo apt-get install -y nvidia-driver-470

# install conda
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
sudo chmod -R 777 ~/.conda
sudo chmod -R  777 /mydata
source ~/.bashrc
# create new env and install package
conda create --name casual_sim_abr python=3.8 -y
conda activate casual_sim_abr
conda install numpy pandas tqdm matplotlib scikit-learn -y
pip install wget latex
sudo apt install texlive-latex-base dvipng texlive texlive-latex-extra cm-super dvipng -y # install latex
pip install tensorboard torch==1.11.0+cu113 torchvision==0.12.0+cu113 torchaudio==0.11.0 --extra-index-url https://download.pytorch.org/whl/cu113

# clone project
cd /mydata
# git clone https://github.com/CausalSim/Unbiased-Trace-Driven-Simulation.git
git clone https://github.com/KFCDeveloper/ML4SysReproduceProjects.git
mv ML4SysReproduceProjects Unbiased-Trace-Driven-Simulation
cd Unbiased-Trace-Driven-Simulation
git checkout -t origin/Unbiased-Trace-Driven-Simulation
# rsync -avz --progress -e ssh /mydata/Unbiased-Trace-Driven-Simulation/abr-puffer/CAUSALSIM_DIR /mydata/Unbiased-Trace-Driven-Simulation/abr-puffer/CAUSALSIM_DIR-20-11-27 /mydata/Unbiased-Trace-Driven-Simulation/abr-puffer/CAUSALSIM_DIR-20-11-27 /mydata/Unbiased-Trace-Driven-Simulation/abr-puffer/CAUSALSIM_DIR-21-1-27 DylanYu@c4130-110233.wisc.cloudlab.us:/mydata/Unbiased-Trace-Driven-Simulation/abr-puffer/
# ln -s abr-puffer/CAUSALSIM_DIR-21-3-27/cooked abr-puffer/CAUSALSIM_DIR-21-3-27/

# prepare dataset
# ** ** 
python3 data_preparation/create_dataset.py --dir CAUSALSIM_DIR-21-5-27/
python data_preparation/generate_subset_data.py --dir CAUSALSIM_DIR-21-3-27/
# train SLSim
python training/sl_subset_train.py --dir CAUSALSIM_DIR-21-3-27/ --left_out_policy linear_bba  # python training/sl_subset_train.py --dir CAUSALSIM_DIR-21-3-27/ --left_out_policy target 
# train CasualSim
python training/train_subset.py --dir CAUSALSIM_DIR-21-3-27/ --left_out_policy linear_bba --C 0.05 

## Training
#  Using CausalSim to extract and save the latent factors ** need
python inference/extract_subset_latents.py --dir CAUSALSIM_DIR-21-3-27/ --left_out_policy linear_bba --C 0.05 
# Counterfactual Simulation
python inference/expert_cfs.py --dir CAUSALSIM_DIR-21-3-27/ # ExpertSim ** need  (pretty time-consuming)
python inference/sl_subset_cfs.py --dir CAUSALSIM_DIR-21-3-27/ --left_out_policy linear_bba # SLSim 
python inference/buffer_subset_cfs.py --dir CAUSALSIM_DIR-21-3-27/ --left_out_policy linear_bba --C 0.05 # CausalSim (pretty time-consuming)
# Calculate the average SSIM using the ground-truth data
python analysis/original_subset_ssim.py --dir CAUSALSIM_DIR-21-3-27/ --left_out_policy linear_bba # ExpertSim ** need
python analysis/sl_subset_ssim.py --dir CAUSALSIM_DIR-21-3-27/ --left_out_policy linear_bba # SLSim 
python analysis/subset_ssim.py --dir CAUSALSIM_DIR-21-3-27/ --left_out_policy linear_bba --C 0.05 # CausalSim ** need
# Calculate the simulated buffer distribution's Earth Mover Distance (EMD) using the fround-truth data
python analysis/subset_EMD.py --dir CAUSALSIM_DIR-20-11-27/ --left_out_policy linear_bba --C 0.05 # All{ExpertSim, SLSim, CausalSim} ** need
# Tune CausalSim's hyper-parameters for buffer and SSIM prediction
python analysis/tune_buffer_hyperparams.py --dir CAUSALSIM_DIR-21-3-27/

# CausalSim model to generate counterfactual downloadtime trajectories
python inference/downloadtime_subset_cfs.py --dir CAUSALSIM_DIR-21-3-27/ --left_out_policy linear_bba --C 0.05  # (pretty time-consuming)
# calculate the average stall ratio
python analysis/original_subset_stall.py --dir CAUSALSIM_DIR-21-3-27/ --left_out_policy linear_bba # ExpertSim 
python analysis/sl_subset_stall.py --dir CAUSALSIM_DIR-21-3-27/ --left_out_policy linear_bba  # SLSim 
python analysis/subset_stall.py --dir CAUSALSIM_DIR-21-3-27/ --left_out_policy linear_bba --C 0.05 # CausalSim 
# Tune CausalSim's hyper-parameters for downloadtime prediction
python analysis/tune_downloadtime_hyperparameters.py --dir CAUSALSIM_DIR-21-3-27/  


# draw Fig4
python visualization/fig4_causal_only.py --dir CAUSALSIM_DIR-21-3-27/
# draw Fig7a
python visualization/fig7a_causal_only.py --dir CAUSALSIM_DIR/

python visualization/fig7a_conbine.py --dir CAUSALSIM_DIR/  # do not change dir