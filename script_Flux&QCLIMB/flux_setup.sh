#!/bin/bash

# https://github.com/ShreyaChak15/flow-prediction  这个人fork了原库，并且有readme，不知道怎么回事，原库是没有readme的
sudo chmod  -R 777 /mydata
cd /mydata
# install git-lfs and download data
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
git lfs install

git clone https://github.com/vojislavdjukic/flux.git
# install conda
cd /mydata
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_24.1.2-0-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
source ~/.bashrc
# create new env and install package
conda create --name flux python=3.8 -y
conda activate flux

pip install scikit-learn matplotlib pandas xgboost keras tensorflow shap

cd /mydata/flux/ml/
python ffnn.py
# 无法运行


# -----------------------------------------------------------------------------------------
cd /mydata
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_24.1.2-0-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
source ~/.bashrc
# create new env and install package
# 安装一下 3.6 试一下别人写的flux的完整版   # https://github.com/ShreyaChak15/flow-prediction
conda create --name flux36 python=3.6 -y
conda activate flux36

pip install scikit-learn==0.21.3
pip install numpy matplotlib pandas xgboost keras tensorflow shap seaborn scikit-garden scikit-learn 
# run test  # callback 报错就直接删除 import callback就行了
cd /mydata/flow-prediction
sh ./test_model.sh
# run RF
cd /mydata/flow-prediction
conda activate flux36
python /mydata/flow-prediction/myfile/RF/RF.py -train

# ------------------------------
# 如果只是运行我的文件，那么可以装 python3.9，并且安装 quantile-forest
git clone https://github.com/KFCDeveloper/ML4SysReproduceProjects.git
mv ML4SysReproduceProjects flow-prediction
cd flow-prediction
git checkout -t origin/flow-prediction

conda create --name flux39 python=3.9 -y
conda activate flux39
pip install numpy matplotlib pandas xgboost keras tensorflow shap seaborn scikit-learn quantile-forest