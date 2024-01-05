#!/bin/bash
# master node
short_hostname=$(hostname --short)

## https://gitlab.engr.illinois.edu/DEPEND/firm/-/blob/master/setup-k8s.md
# Install Docker
sudo apt update
sudo apt install -y docker.io
docker -v
# Start and Enable Docker
sudo systemctl enable docker
sudo systemctl start docker
# Install Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt install -y kubeadm kubelet kubectl
sudo apt-mark hold kubeadm kubelet kubectl
kubeadm version
# Deploy Kubernetes
sudo swapoff -a
# sudo hostnamectl set-hostname your_hostname
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl get pods --all-namespaces

## Deploy FIRM  https://gitlab.engr.illinois.edu/DEPEND/firm/-/tree/master?ref_type=heads
cd ~
git clone https://gitlab.engr.illinois.edu/DEPEND/firm.git
sudo apt install -y python3-pip
pip3 install --upgrade pip
python3 -m pip install --upgrade setuptools
cd firm/
# pip3 install -r requirements.txt # something wrong with the packages
pip3 install joblib==0.15.1 falcon==2.0.0 requests==2.18.4 matplotlib==3.1.3 wheel==0.30.0 numpy==1.18.1 redis==3.5.3 grpcio==1.31.0 torch==1.6.0 env==0.1.0 h5py==2.10.0 ipython Pillow==7.2.0 python_dateutil==2.8.1 scikit_learn==0.23.2 neo4j==4.1.0 grpcio-tools==1.30.0
cd anomaly-injector
make
cd sysbench
./autogen.sh
sudo apt install -y libmysqlclient-dev # lack MySQL libraries
./configure
make -j
sudo make install

# Deploy tracing, metrics exporting, collection agents:
