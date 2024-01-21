#!/bin/bash

## 
cd /mydata
sudo chmod -R  777 /mydata
sudo chmod -R  777 ~

# install noise page
cd /mydata
git clone https://github.com/cmu-db/noisepage.git
cd noisepage
sudo ./script/installation/packages.sh
mkdir build
cd build
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DNOISEPAGE_USE_JEMALLOC=ON -DNOISEPAGE_UNITY_BUILD=ON ..
ninja noisepage
./bin/noisepage