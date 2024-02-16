#!/bin/bash

git clone https://gitlab.engr.illinois.edu/DEPEND/aware.git
cd rl-controller

conda create --name aware python=3.10 -y
conda activate aware
pip install -r requirements.txt