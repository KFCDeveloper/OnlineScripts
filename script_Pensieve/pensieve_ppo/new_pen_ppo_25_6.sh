# ubuntu 22
# machine with GPU is unnecessary
sudo chmod -R  777 /mydata
sudo apt update
cd /mydata

# install conda
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_24.1.2-0-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
sudo chmod -R 777 ~/.conda
sudo chmod -R  777 /mydata
source ~/.bashrc

# create new env and install package
conda create --name pensieve_ppo python=3.9 -y
conda activate pensieve_ppo
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124  # cu124 cu118
pip3 install matplotlib scipy tensorboard

# or download from one drive
# git clone
git clone https://github.com/KFCDeveloper/ML4SysReproduceProjects.git
cd ML4SysReproduceProjects
git checkout -t origin/Pensieve-PPO
cd ..
mv ML4SysReproduceProjects Pensieve-PPO

# 
