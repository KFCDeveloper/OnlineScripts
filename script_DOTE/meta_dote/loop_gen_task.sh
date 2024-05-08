#!/bin/bash

conda activate ydy-dote
edges=("('0', '1')" "('0', '2')" "('1', '10')" "('2', '9')" "('3', '4')" "('3', '6')" "('4', '5')" "('4', '6')" "('5', '8')" "('6', '7')" "('7', '8')" "('7', '10')" "('8', '9')" "('9', '10')")
for ((i=0; i<${#edges[@]}; i++)); # i=0; i<${#edges[@]};
do
    for ((j=i+1; j<${#edges[@]}; i++));
    do  
        cd /mydata/DOTE/networking_envs/data/
        python loop_gml_to_dote.py "Abilene" "${edges[i]}" "${edges[j]}"
        # don't forget!! To compute the optimum for the demand matrices, go to /mydata/DOTE/networking_envs/data/Abilene and run /mydata/DOTE/networking_envs/data/compute_opts.py
        cd "/data/ydy/myproject/DOTE/networking_envs/data/Abilene-${edges[i]}-${edges[j]}"
        python /data/ydy/myproject/DOTE/networking_envs/data/loop_compute_opts.py "Abilene-${edges[i]}-${edges[j]}"
    done
done