#!/bin/bash

# https://ken.io/note/docker-swarm-cluster-setup-and-manage; compose cluster
# *** manager
sudo docker swarm init --advertise-addr=128.105.144.182 # ifconfig
docker swarm join-token worker # obtain instruction of worker node joining
# docker swarm init --advertise-addr=c220g5-111012.wisc.cloudlab.us --force-new-cluster
# *** worker
sudo docker swarm join --token xxxxxxxxxx 10.0.10.131:2377


docker stack deploy --compose-file=docker-compose-swarm.yml <service-name>