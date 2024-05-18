#!/bin/bash

cd /mydata/DOTE/networking_envs/save_models/drop_data_model
# change Dmdataset


python3 /mydata/DOTE/dote.py --ecmp_topo GEANT-obj1 --paths_from sp --so_mode test --so_epochs 5 --so_batch_size 32 --opt_function MAXUTIL