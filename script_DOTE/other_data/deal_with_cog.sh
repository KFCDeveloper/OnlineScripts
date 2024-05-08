
cd /mydata/DOTE/networking_envs/data/
/mydata/miniconda3/envs/dote/bin/python loop_gml_to_dote.py "Cogentco" "('0', '9')" "('1', '8')"
# don't forget!! To compute the optimum for the demand matrices, go to /mydata/DOTE/networking_envs/data/Abilene and run /mydata/DOTE/networking_envs/data/compute_opts.py
cd "/mydata/DOTE/networking_envs/data/Cogentco-2-('0', '9')-('1', '8')"
/mydata/miniconda3/envs/dote/bin/python /mydata/DOTE/networking_envs/data/loop_compute_opts.py "Cogentco-2-('0', '9')-('1', '8')"