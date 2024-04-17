#!/bin/bash
## 
cd /mydata
sudo chmod -R  777 /mydata
sudo chmod -R  777 ~
# install nvidia-driver
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get install -y nvidia-driver-470

# install conda
cd /mydata
sudo mkdir -p /mydata/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_24.1.2-0-Linux-x86_64.sh -O /mydata/miniconda3/miniconda.sh
sudo bash /mydata/miniconda3/miniconda.sh -b -u -p /mydata/miniconda3
sudo /mydata/miniconda3/bin/conda init bash
/mydata/miniconda3/condabin/conda create --name pensieve python=3.8 -y
source ~/.bashrc
sudo chmod -R 777 ~/.conda/
sudo chmod -R  777 /mydata

# mahimahi
mkdir -p /mydata/software/pensive
cd /mydata/software/pensive
#! use `sysctl net.ipv4.ip_forward` to check whether net.ipv4.ip_forward==1
# sudo sysctl -w net.ipv4.ip_forward=1
sudo add-apt-repository -y ppa:keithw/mahimahi
sudo apt-get -y update
sudo apt-get -y install mahimahi

# apache server
sudo apt-get -y install apache2

# selenium
conda activate pensieve
cd /mydata/software/pensive
wget 'https://pypi.python.org/packages/source/s/selenium/selenium-2.39.0.tar.gz'
sudo apt-get -y install xvfb xserver-xephyr tightvncserver unzip # python-setuptools python-pip
tar xvzf selenium-2.39.0.tar.gz
cd /mydata/software/pensive/selenium-2.39.0
python setup.py install    # sudo python setup.py install # pip 
sudo sh -c "echo 'DBUS_SESSION_BUS_ADDRESS=/dev/null' > /etc/init.d/selenium"

# py virtual display
cd /mydata/software/pensive
pip install pyvirtualdisplay   # sudo pip install pyvirtualdisplay
sudo apt-get install fonts-liberation libnspr4 libnss3 libu2f-udev libvulkan1 xdg-utils
wget 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
sudo dpkg -i google-chrome-stable_current_amd64.deb
# sudo apt-get -f -y install

# tensorflow
# sudo apt-get -y install python-pip python-dev
# sudo pip install tensorflow
pip install nvidia-pyindex
pip install nvidia-tensorflow[horovod]==1.15.5+nv22.07    #21.8  1.15.5+nv22.07  nvidia_tensorflow-1.15.4+nv20.12-cp38-cp38-linux_x86_64.whl
pip install nvidia-tensorboard==1.15

# tflearn
# pip install tflearn # sudo 
# sudo apt-get -y install python-h5py
# pip install h5py
# sudo apt-get -y install python-scipy
# pip install scipy
# matplotlib
# sudo apt-get -y install python-matplotlib
# pip install matplotlib
# !!!! numpy must be 1.20.0  Pillow==9.5.0
pip install numpy==1.20.0 tflearn h5py scipy==1.10.1 matplotlib==3.7.5 pyvirtualdisplay Pillow==9.5.0

# copy the webpage files to /var/www/html
cd /mydata/pensieve
sudo cp video_server/myindex_*.html /var/www/html
sudo cp video_server/dash.all.min.js /var/www/html
sudo cp -r video_server/video* /var/www/html
sudo cp video_server/Manifest.mpd /var/www/html

# make results directory
mkdir sim/cooked_traces
mkdir rl_server/results
mkdir run_exp/results
mkdir real_exp/results

#! need to copy the trace and pre-trained NN model
# print "Need to put trace files in 'pensieve/cooked_traces'."
# print "Need to put pre-trained NN model in 'pensieve/rl_server/results'."

## Execute
# link of dataset https://github.com/hongzimao/pensieve/issues/134 
# train
cd /mydata/pensieve/sim
/mydata/miniconda3/envs/pensieve/bin/python /mydata/pensieve/sim/get_video_sizes.py
/mydata/miniconda3/envs/pensieve/bin/python multi_agent.py
