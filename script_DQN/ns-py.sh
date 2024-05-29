#!/bin/bash

cd /mydata
sudo chmod -R  777 /mydata

git clone https://github.com/TL-System/ns.py.git
# make sure you have anaconda
conda create -n ns.py python=3.9
conda activate ns.py
conda install pandas=1.1.5 scipy=1.10.1 seaborn=0.12.2 tqdm matplotlib=3.7.2 jupyter notebook -y
pip install simpy networkx
# install ns.py using pip
# pip install ns.py #!!! don't do this
# run some examples
# cd /mydata/ns.py/examples
# python tcp.py

# python examples/my_simu/tcp_.py

# # Testing the emulation mode with simple TCP and UDP echo servers
# python examples/real_traffic/tcp_echo_server.py 10000
# python examples/real_traffic/proxy.py 5000 localhost 10000 tcp

# run my code
/mydata/miniconda3/envs/ns.py/bin/python /mydata/ns.py/no_tcp_.py
# have a look at /mydata/ns.py/2.txt
/mydata/miniconda3/envs/ns.py/bin/python /mydata/ns.py/fattree.py