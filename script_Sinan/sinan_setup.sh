#!/bin/bash
# don't need to care abount social network, sinan use code to start social network
#(run this on each server)wget -O - https://raw.githubusercontent.com/KFCDeveloper/OnlineScripts/main/script_Sinan/social_network_setup_auto.sh | bash
#(master node)sudo docker swarm init --advertise-addr $(curl -s icanhazip.com)
#(slave node) sudo docker swarm join --token SWMTKN-1-3e290ee10t87o8t74ijncaie0whbpuh2u3trej3u77l4utna28-6c6yo36aslqzkl6mi3lmqa4gi 128.105.144.47:2377

# each node git clone sinan-local
cd /mydata
sudo chmod -R 777 /mydata
# git clone https://github.com/zyqCSL/sinan-local.git
git clone https://github.com/KFCDeveloper/ML4SysReproduceProjects.git
mv ML4SysReproduceProjects sinan-local
cd sinan-local
git checkout -t origin/sinan-local
git pull




## Service cluster configuration
# Modify ip and cpu num !!
cd /mydata/sinan-local/docker_swarm/misc/
conda deacitvate
conda activate sinan
pip install docker

python3 make_cluster_config.py --nodes ath-8 ath-9 ath-5 --cluster-config test_cluster.json --replica-cpus 4

## Inference engine configuration 
# Modify gpu py config !!
python3 make_gpu_config.py --gpu-config gpu.json

# Setting up docker swarm cluster
cd /mydata/sinan-local/docker_swarm/
# add $USER to docker group
sudo groupadd docker
sudo usermod -aG docker $USER
getent group docker 
newgrp docker # reboot can permanent add # !!activate the changes to groups; don't know why, but need to run this each time u run setup_swarm_cluster.py
conda activate sinan
# !! gpu computer need generate pub key; slaves need to add pubkey # ssh-keygen -t rsa
# !! slave also need to do # sudo groupadd docker # sudo usermod -aG docker $USER
python3 setup_swarm_cluster.py --user-name DylanYu --deploy-config test_cluster.json # yz2297 is everywhere; use it can avoid trouble



## Data collection

# !! all the machine should have all the pub key, including themselves.
# !! change mode, for each machine # sudo chmod -R 777 /mydata
# cd /mydata/sinan-local/docker_swarm/scripts
# ./run_data_collect.sh   # store data in docker_swarm/logs/collected_data # it is running  master_data_collect_ath_social.py
cd /mydata/sinan-local/docker_swarm/
# python3 master_data_collect_ath_social.py --user-name DylanYu \
# 	--stack-name sinan-socialnet \
# 	--min-users 4 --max-users 8 --users-step 2 \
# 	--exp-time 60 --measure-interval 1 --slave-port 40011 --deploy-config swarm_ath.json \
# 	--mab-config social_mab.json --deploy
python3 master_data_collect_ath_social.py --user-name DylanYu \
	--stack-name sinan-socialnet \
	--min-users 4 --max-users 48 --users-step 2 \
	--exp-time 1200 --measure-interval 1 --slave-port 40011 --deploy-config swarm_ath.json \
	--mab-config social_mab.json --deploy


## Training Model
cd /mydata/sinan-local/ml_docker_swarm
