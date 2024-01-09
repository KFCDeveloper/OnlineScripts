#!/bin/bash
## master node
sudo mkfs.ext4 /dev/sda4
sudo mount /dev/sda4 ~
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get install -y nvidia-driver-470
