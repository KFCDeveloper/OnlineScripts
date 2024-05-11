#!/bin/bash

cd /mydata/DOTE/networking_envs/save_models/drop_data_model
/mydata/miniconda3/envs/dote/bin/python /mydata/DOTE/dote.py --ecmp_topo GEANT --paths_from sp --so_mode train --so_epochs 200 --so_batch_size 32 --opt_function MAXFLOW # MAXUTIL