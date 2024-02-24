#!/bin/bash

targets=("bola_basic_v1" "bola_basic_v2")  # "linear_bba"
root_dirs=("CAUSALSIM_DIR-21-1-27/" "CAUSALSIM_DIR-21-3-27/")   # "CAUSALSIM_DIR/" "CAUSALSIM_DIR-20-9-27/" "CAUSALSIM_DIR-20-11-27/" 
c_s=("0.1" "0.5" "1.0" "5.0" "10.0" "15.0" "20.0" "25.0" "30.0" "40.0")    # "0.05"
edges=("('0', '1')" "('0', '2')" "('1', '10')" "('2', '9')" "('3', '4')" "('3', '6')" "('4', '5')" "('4', '6')" "('5', '8')" "('6', '7')" "('7', '8')" "('7', '10')" "('8', '9')" "('9', '10')")
for target in "${targets[@]}"
do
    for root_dir in "${root_dirs[@]}"
    do  
        cd /data/ydy/myproject/DOTE/networking_envs/data/
        python loop_gml_to_dote.py 'Abilene' '-squeeze-links'
        # don't forget!! To compute the optimum for the demand matrices, go to /mydata/DOTE/networking_envs/data/Abilene and run /mydata/DOTE/networking_envs/data/compute_opts.py
        cd /data/ydy/myproject/DOTE/networking_envs/data/Abilene-squeeze-links-more1
        python /data/ydy/myproject/DOTE/networking_envs/data/loop_compute_opts.py 'Abilene-squeeze-links-more1'