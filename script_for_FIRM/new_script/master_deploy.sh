#!/bin/bash

## !make sure your master node can supporst MBA and CAT; you would better use 
lscpu | grep cat
lscpu | grep mba
uname -a
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
# sudo git clone https://github.com/KFCDeveloper/firm.git # https://gitlab.engr.illinois.edu/DEPEND/firm.git
cd firm/
# pip3 install -r requirements.txt # something wrong with the packages
source ~/.bashrc
conda activate firm
pip3 install joblib==0.15.1 falcon==2.0.0 requests==2.18.4 matplotlib==3.1.3 wheel==0.30.0 numpy==1.18.1 redis==3.5.3 grpcio==1.31.0 torch==1.6.0 env==0.1.0 h5py==2.10.0 ipython Pillow==7.2.0 python_dateutil==2.8.1 scikit_learn==0.23.2 neo4j==4.1.0 grpcio-tools==1.30.0 aiohttp
# On each node, install anomaly injector:
cd /mydata/firm/anomaly-injector
sudo make

cd pmbw-0.6.2
./configure && make
cd ..
sudo apt -y install make automake libtool pkg-config libaio-dev libmysqlclient-dev libssl-dev iproute2

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

# first install intel cmt cat (otherwise "cd python-cat-mba" and make env will have bug)
cd /mydata/firm/third-party/intel-cmt-cat
make all
make install 
# (not in the contrainer)Install deployment module:
cd /mydata/firm/scripts
make all
cd python-cat-mba
# make env # just install python; maybe don't need

####***** Set Up Microservice Benchmarks With Tracing Enabled

# dns
kubectl get service -n kube-system
#! benchmarks/1-social-network/nginx-web-server/conf/nginx-k8s.conf (line 44)
#! <path-of-repo>/benchmarks/1-social-network/media-frontend/conf/nginx-k8s.conf (line 37)

# Deploy Services
#! Change the /mydata/firm/ to <path-of-repo> in media-frontend.yaml and nginx-thrift.yaml under the <path-of-repo>/benchmarks/1-social-network/k8s-yaml directory.
kubectl apply -f /mydata/firm/benchmarks/1-social-network/k8s-yaml/social-network-ns.yaml
kubectl apply -f /mydata/firm/benchmarks/1-social-network/k8s-yaml/
# previous command has error "compose-post-redis exits", a little bit weird.
kubectl -n social-network get pod

# Setup Services
kubectl -n social-network get svc nginx-thrift # get its cluster IP
#! modify /mydata/firm/benchmarks/1-social-network/scripts/init_social_graph.py line 74.
conda activate firm
cd /mydata/firm/benchmarks/1-social-network/
python3 ./scripts/init_social_graph.py # Register users and construct social graph 

####***** To Run

# Anomaly Injection
#! download share_all_pub_key.py and run it on ** your machine **
#! Configure the machine IP address  in `firm/anomaly-injector/injector.py`
# ** each node **: prepare files for generating disk I/O contention:
cd /mydata/firm/anomaly-injector/
mkdir test-files
cd test-files
sysbench fileio --file-total-size=150G prepare

# On Master To run anomaly injection ! you'd better run this in a tmux session
cd /mydata/firm/anomaly-injector/
python3 injector.py

# Workload Generation
#! configure cluster IP; use output of `kubectl -n social-network get svc nginx-thrift` 
# /mydata/firm/benchmarks/1-social-network/wrk2/scripts/social-network/compose-post.lua:66;
# /mydata/firm/benchmarks/1-social-network/wrk2/scripts/social-network/read-home-timeline.lua:16;
# /mydata/firm/benchmarks/1-social-network/wrk2/scripts/social-network/read-user-timeline.lua:16;
# build the workload generator
cd /mydata/firm/benchmarks/1-social-network/wrk2  
make
#! To run workload generation; change the cluster ip using output of `kubectl -n social-network get svc nginx-thrift`
sudo luarocks install luasocket #! check each node
# you'd better run it in tmux
./wrk -D exp -t 8 -c 100 -R 1600 -d 1h -L -s /mydata/firm/benchmarks/1-social-network/wrk2/scripts/social-network/compose-post.lua http://10.107.132.35:8080/wrk2-api/post/compose

# SVM Training
# generate training dataset:
cd /mydata/firm/data/social-network/svm_dataset
#! configure cluster IP; 
python /mydata/firm/metrics/analysis/cpa-training-labels.py #! you'd better run it in a tmux session # 15:42 
#! change localhost to neo4j's cluster ip in the output of `kubectl get svc --all-namespaces`
python /mydata/firm/metrics/analysis/cpa-training-features.py #! you'd better run it in a tmux session

# RL Training
# install if needed: sudo apt install redis-server
sudo systemctl start redis
sudo vim /etc/redis/redis.conf  #! comment out `bind x.x.x.x` line and add `bind 0.0.0.0`
sudo systemctl restart redis
# run metrics collector and store metrics in redis:
python /mydata/firm/metrics/collector/collector.py #! you'd better run it in a tmux session
# run sender which polls cAdvisor via its REST API:
#! replace /path/to/repository in metrics/sender/cron/crontab
#! replace the IP address of the machine running cAdvisor and collector in `sender.py` COLLECTOR_URL, CADVISOR_URL
# you'd better install /mydata/firm/third-party/cAdvisor first
# sudo apt install golang-go -y
# cd /mydata/firm/third-party/cAdvisor
# make all
sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  gcr.io/cadvisor/cadvisor:v0.36.0

crontab /mydata/firm/metrics/sender/cron/crontab # python /mydata/firm/metrics/sender/sender.py



