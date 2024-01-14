#!/bin/bash

# ******* MimicNet cannot been deployed **********

# sudo add-apt-repository -y ppa:graphics-drivers/ppa
# ubuntu-drivers devices
# sudo apt-get install -y nvidia-driver-470
sudo apt install tmux

# sudo mkfs.ext4 /dev/sda4
# sudo mount /dev/sda4 ~

# to test x11
sudo apt-get install xorg
sudo apt-get install xauth
xclock

# install docker
sudo apt install docker.io
sudo service docker stop
# do the project in the docker
# change the docker images savign path /etc/docker/daemon.json
# {"graph": "/mydata/docker-image/storage"}
# sudo service docker stop
sudo service docker start
# df -h ~ # make sure your disk space is enough
# sudo docker pull pytorch/pytorch-binary-docker-image-ubuntu16.04:new
# run the image  
sudo docker run -it --name mymimicnet  -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -d pytorch/pytorch-binary-docker-image-ubuntu16.04 /bin/bash
sudo docker run -it --name mymimicnet-0 --net=host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -d pytorch/pytorch-binary-docker-image-ubuntu16.04 /bin/bash
sudo docker run -it --name mymimicnet-1 --net=host -e DISPLAY=$DISPLAY --volume="$HOME/.Xauthority:/root/.Xauthority:rw" -d pytorch/pytorch-binary-docker-image-ubuntu16.04 /bin/bash

sudo apt install x11-apps

# run the container
# sudo docker exec -it 76c30bbd0cc0 /bin/bash
# if you reboot the server, you need to follow the step
# 1. sudo mount /dev/sda4 ~
# 2. sudo service docker restart
# 3. sudo docker start -i mymimicnet
# 4. sudo docker exec -it mymimicnet /bin/bash
# if you want to save the running container

# create new user
# adduser mimicnet
# usermod -aG sudo mimicnet
# su mimicnet
# export DISPLAY=:0.0

## ssh after mount disk
# sudo mkdir ./.ssh
# sudo touch ~/.ssh/authorized_keys
# sudo vim ~/.ssh/authorized_keys
# and then copy your pub key to authorized_keys

# make sure entered the docker
cd ~
sudo apt-get update
apt-get install sudo -y
sudo apt-get install -y openssh-server
sudo service ssh restart
sudo apt-get install xorg
# sudo apt install x11-apps
git clone https://github.com/eniac/MimicNet.git
