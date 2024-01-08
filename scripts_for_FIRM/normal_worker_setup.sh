#!/bin/bash
# worker node
## mount /dev/sda4 to ~/workspace   that's for CloudLab
sudo mkfs.ext4 /dev/sda4
sudo mount /dev/sda4 ~

## Setup Kubernetes Cluster    https://gitlab.engr.illinois.edu/DEPEND/firm/-/blob/master/setup-k8s.md
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
# sudo kubeadm join 155.98.36.73:6443 --token tp63zc.yszu8p1nw7jg7rzn --discovery-token-ca-cert-hash sha256:02fff666076d5a8c968b09a3ec38056b98c7ab224b3ffec4206b45098753429a

## Deploy FIRM  https://gitlab.engr.illinois.edu/DEPEND/firm/-/tree/master?ref_type=heads
cd ~
git clone https://github.com/KFCDeveloper/firm.git # https://gitlab.engr.illinois.edu/DEPEND/firm.git
sudo apt install -y python3-pip
pip3 install --upgrade pip
python3 -m pip install --upgrade setuptools
cd firm/
# pip3 install -r requirements.txt # something wrong with the packages
pip3 install joblib==0.15.1 falcon==2.0.0 requests==2.18.4 matplotlib==3.1.3 wheel==0.30.0 numpy==1.18.1 redis==3.5.3 grpcio==1.31.0 torch==1.6.0 env==0.1.0 h5py==2.10.0 ipython Pillow==7.2.0 python_dateutil==2.8.1 scikit_learn==0.23.2 neo4j==4.1.0 grpcio-tools==1.30.0
# On each node, install anomaly injector:
cd anomaly-injector
make
cd sysbench
./autogen.sh
sudo apt install -y libmysqlclient-dev # lack MySQL libraries
./configure
make -j
sudo make install

# Deploy tracing, metrics exporting, collection agents:
cd ~/firm
export NAMESPACE='monitoring'
kubectl create -f manifests/setup
kubectl create namespace observability
kubectl create -n observability -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/v1.27.0/deploy/crds/jaegertracing.io_jaegers_crd.yaml
kubectl create -n observability -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/v1.27.0/deploy/service_account.yaml
kubectl create -n observability -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/v1.27.0/deploy/role.yaml
kubectl create -n observability -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/v1.27.0/deploy/role_binding.yaml
kubectl create -n observability -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/v1.27.0/deploy/operator.yaml
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/v1.27.0/deploy/cluster_role.yaml
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/v1.27.0/deploy/cluster_role_binding.yaml
kubectl create -f manifests/

# Install deployment module:
exit # leave container
cd ~/firm/third-party/intel-cmt-cat
sudo make install # you need to make intel-cmt-cat otherwise there is no libs of intel-cmt-cat in /lib
cd ~/firm/scripts   # because author's 
make all
# need to install virtualenv before "make env"
pip3 install virtualenv
cd python-cat-mba
make env    # I remove "make -C ../../lib/python install; \"  it is weird
