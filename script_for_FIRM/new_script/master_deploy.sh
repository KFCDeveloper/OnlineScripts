#!/bin/bash

## Deploy Kubernetes
# sudo rm -rf /etc/containerd/config.toml
# sudo systemctl restart containerd
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl get pods --all-namespaces
# kubeadm token create --print-join-command

## Deploy FIRM  https://gitlab.engr.illinois.edu/DEPEND/firm/-/tree/master?ref_type=heads
cd /mydata
sudo git clone https://github.com/KFCDeveloper/firm.git # https://gitlab.engr.illinois.edu/DEPEND/firm.git
cd firm/
# pip3 install -r requirements.txt # something wrong with the packages
sudo pip3 install joblib==0.15.1 falcon==2.0.0 requests==2.18.4 matplotlib==3.1.3 wheel==0.30.0 numpy==1.18.1 redis==3.5.3 grpcio==1.31.0 torch==1.6.0 env==0.1.0 h5py==2.10.0 ipython Pillow==7.2.0 python_dateutil==2.8.1 scikit_learn==0.23.2 neo4j==4.1.0 grpcio-tools==1.30.0
# On each node, install anomaly injector:
cd anomaly-injector
sudo make
cd sysbench
sudo ./autogen.sh
sudo apt install -y libmysqlclient-dev # lack MySQL libraries  
sudo ./configure
sudo make -j
sudo make install
# Deploy tracing, metrics exporting, collection agents:
cd /mydata/firm
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
# Deploy graph database and pipeline for metrics storage
cd trace-grapher
sudo docker-compose run stack-builder
# now a shell pops as root in the project directory of the stack-builder container
cd deploy-trace-grapher
make prepare-trace-grapher-namespace
make install-components
