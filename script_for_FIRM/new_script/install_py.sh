#!/bin/bash
# wget -O - https://raw.githubusercontent.com/KFCDeveloper/OnlineScripts/main/script_for_FIRM/new_script/install_py.sh | bash

# cd /mydata/firm
# git pull

# source ~/.bashrc
# # create new env and install package
# /mydata/miniconda3/condabin/conda create --name firm python=3.7 -y
# /mydata/miniconda3/condabin/conda activate firm

# cd /mydata/firm/anomaly-injector
# sudo make
# cd sysbench
# sudo ./autogen.sh
# sudo apt install -y libmysqlclient-dev # lack MySQL libraries  
# sudo ./configure
# sudo make -j
# sudo make install

cd /mydata/firm/anomaly-injector/
mkdir test-files
cd test-files
sysbench fileio --file-total-size=150G prepare