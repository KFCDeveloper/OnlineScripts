#!/bin/bash

cd /mydata/sinan-local/docker_swarm/misc/
source ~/.bashrc
conda activate sinan
pip install docker
python3 make_cluster_config.py --nodes ath-8 ath-9 --cluster-config test_cluster.json --replica-cpus 4