#!/bin/bash

# conda activate ydy-dote
# # in tfgirl dir env
# cd /data/ydy/myproject/DOTE/networking_envs/data/
# mkdir -p /data/ydy/myproject/DOTE/networking_envs/data/zoo_topologies
# wget http://www.topology-zoo.org/files/Abilene.gml
# # /networking_envs/data/gml_to_dote.py, set the src_dir, dest_dir and network_name variables.
# cd /data/ydy/myproject/DOTE/networking_envs/data/
# python loop_gml_to_dote.py 'Abilene' '-squeeze-links'
# # don't forget!! To compute the optimum for the demand matrices, go to /mydata/DOTE/networking_envs/data/Abilene and run /mydata/DOTE/networking_envs/data/compute_opts.py
# cd /data/ydy/myproject/DOTE/networking_envs/data/Abilene-squeeze-links-more1
# python /data/ydy/myproject/DOTE/networking_envs/data/loop_compute_opts.py 'Abilene-squeeze-links-more1'


# python loop_gml_to_dote.py "Abilene" "('1', '10')" "('2', '9')"

# after loop_gen_task; train the Meta learner
python3 /mydata/DOTE/meta_dote.py --ecmp_topo Abilene-squeeze-links-more1 --paths_from sp --so_mode meta-train --so_epochs 20 --so_batch_size 32 --opt_function MAXUTIL

python3 /mydata/DOTE/myfile/progressive_direct_transfer/dote_prog.py --ecmp_topo Abilene --paths_from sp --so_mode train --so_epochs 50 --so_batch_size 200 --opt_function MAXFLOW