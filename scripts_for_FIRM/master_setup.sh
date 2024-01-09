#!/bin/bash
## master node

sudo su DylanYu # **** change user name ****
# export HOME="/users/DylanYu"

## mount /dev/sda4 to ~/workspace   that's for CloudLab
sudo mkfs.ext4 /dev/sda4
sudo mount /dev/sda4 ~

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
# If you forget the command or the token is expired, run "kubeadm token create --print-join-command" on master node
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
sudo mkdir -p $HOME/.kube
echo "********************** create kube"
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl get pods --all-namespaces

## Deploy FIRM  https://gitlab.engr.illinois.edu/DEPEND/firm/-/tree/master?ref_type=heads
cd ~
sudo git clone https://github.com/KFCDeveloper/firm.git # https://gitlab.engr.illinois.edu/DEPEND/firm.git
sudo apt install -y python3-pip
sudo pip3 install --upgrade pip
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
# Deploy graph database and pipeline for metrics storage (this requires docker-compose to be installed and enabled on the master node):
cd trace-grapher
# sudo apt install -y docker-compose  <waiting to check>
sudo docker-compose run stack-builder # need to modify version to 3.3
# now a shell pops as root in the project directory of the stack-builder container
cd deploy-trace-grapher
make prepare-trace-grapher-namespace
make install-components # cannot execute 
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
