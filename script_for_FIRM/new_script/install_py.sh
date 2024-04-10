#!/bin/bash
# wget -O - https://raw.githubusercontent.com/KFCDeveloper/OnlineScripts/main/script_for_FIRM/new_script/install_py.sh | bash

source ~/.bashrc
# create new env and install package
/mydata/miniconda3/condabin/conda create --name firm python=3.7 -y
/mydata/miniconda3/condabin/conda activate firm