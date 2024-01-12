#!/bin/bash
# sudo add-apt-repository -y ppa:graphics-drivers/ppa
# ubuntu-drivers devices
# sudo apt-get install -y nvidia-driver-470

sudo mkfs.ext4 /dev/sda4
sudo mount /dev/sda4 ~

# install docker
apt install docker.io
sudo service docker stop
# do the project in the docker
# change the docker images savign path /etc/docker/daemon.json
# {"graph": "/users/DylanYu/image/storage"}
# sudo service docker stop
sudo service docker start
df -h ~ # make sure your disk space is enough
sudo docker pull pytorch/pytorch-binary-docker-image-ubuntu16.04:new
# run the image  
docker run -it --name mymimicnet -d pytorch/pytorch-binary-docker-image-ubuntu16.04 /bin/bash
# run the container
# sudo docker exec -it 2814b92c9ed8 /bin/bash
# if you reboot the server, you need to follow the step
# 1. sudo mount /dev/sda4 ~
# 2. sudo service docker restart
# 3. sudo docker start -i mymimicnet
# 3. sudo docker exec -it mymimicnet /bin/bash
# if you want to save the running container

# create new user
adduser mimicnet
usermod -aG sudo mimicnet
su mimicnet
cd ~
git clone https://github.com/eniac/MimicNet.git