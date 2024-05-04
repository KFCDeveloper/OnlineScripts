#!/bin/bash

mkdir -p /mydata/ns3
cd /mydata/ns3
wget https://www.nsnam.org/releases/ns-allinone-3.41.tar.bz2  # ns-allinone-3.41.tar.bz2
tar xfj ns-allinone-3.41.tar.bz2
cd ns-allinone-3.41/ns-3.41

./ns3 configure --enable-examples --enable-tests
# install cmake
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | sudo apt-key add -
sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
sudo apt-get update
sudo apt install cmake
# install gcc
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install gcc-9 g++-9
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 # prioritize gcc-9 instead of gcc # https://blog.csdn.net/asfh555/article/details/131752064

# install ns3
