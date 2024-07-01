
# https://github.com/carpedm20/ENAS-pytorch.git
# 这个不是原来的 repo，是别人的


sudo apt-get update
sudo apt-get install tmux

cd /mydata
sudo chmod -R  777 /mydata
# install nvidia-driver
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt install ubuntu-drivers-common -y
ubuntu-drivers devices
sudo apt-get install -y nvidia-driver-470


cd /mydata
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_24.1.2-0-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
source ~/.bashrc
/mydata/miniconda3/condabin/conda create --name enas1 python=3.6 -y
conda activate enas1

# conda install graphviz
sudo apt-get install graphviz graphviz-dev
conda install --channel conda-forge pygraphviz
conda install ipdb tqdm scipy==1.2.1 imageio torchvision tensorboardX Pillow==6.0.0
conda install pytorch=0.4.1 -c pytorch
# pip install torch==1.10.0+cu113 --extra-index-url https://download.pytorch.org/whl/cu113
pip install opencv-contrib-python==3.4.8.29

# *************** conda activate enas1
# pip install ipdb tqdm scipy imageio torch torchvision tensorboardX Pillow opencv-contrib-python

