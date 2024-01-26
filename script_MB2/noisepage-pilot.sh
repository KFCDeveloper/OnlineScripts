#!/bin/bash

sudo chmod -R  777 /mydata
conda create --name mb2 python=3.8 -y
conda activate mb2


cd /mydata
git clone https://github.com/cmu-db/noisepage-pilot.git
cd noisepage-pilot
git submodule update --init --recursive
cd behavior/modeling/featurewiz && pip3 install --upgrade -r requirements.txt
pip3 install --upgrade -r requirements.txt
pip3 install doit plumbum

doit list
