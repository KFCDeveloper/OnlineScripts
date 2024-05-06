#!/bin/bash
# ! make sure you are using ** ubuntu 22 ** not 18
sudo chmod -R 777 /mydata
mkdir -p /mydata/ns3
cd /mydata/ns3
wget https://www.nsnam.org/releases/ns-allinone-3.41.tar.bz2  # ns-allinone-3.41.tar.bz2
tar xfj ns-allinone-3.41.tar.bz2
cd ns-allinone-3.41/ns-3.41

./ns3 configure --enable-examples --enable-tests
# install cmake
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | sudo apt-key add -
sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ jammy main'  # jammy   bionic
sudo apt-get update
sudo apt install cmake
# # install gcc
# sudo add-apt-repository ppa:ubuntu-toolchain-r/test
# sudo apt-get update
# sudo apt-get install gcc-9 g++-9
# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 # prioritize gcc-9 instead of gcc # https://blog.csdn.net/asfh555/article/details/131752064
# sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 90
# # install clang 10
# wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
# # sudo vim /etc/apt/source.list.d/llvm-10.list
# sudo apt update
# sudo apt install clang-10
# # 安装 AST.h 等头文件
# sudo apt install libclang-10-dev
# sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-10 10000
# sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-10 10000
# sudo update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-10 10000

# install ns3
./ns3 build

# run script https://www.nsnam.org/docs/release/3.41/tutorial/html/getting-started.html#running-a-script
