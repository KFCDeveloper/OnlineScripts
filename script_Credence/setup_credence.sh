#!/bin/bash


git clone https://github.com/inet-tub/ns3-datacenter.git

sudo apt update
sudo apt install cmake
# Configure ns3
cd /mydata/ns3-datacenter/simulator/ns-3.39/
./configure.sh

# Build
cd /mydata/ns3-datacenter/simulator/ns-3.39/
./waf