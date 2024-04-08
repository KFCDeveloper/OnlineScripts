#!/bin/bash

cd /mydata/DOTE/networking_envs/save_models
# !! to change the merging approach of two vectors # arg ecmp_topo not important
python3 /mydata/DOTE/meta_dote.py --ecmp_topo Abilene-squeeze-links-more1 --paths_from sp --so_mode meta-train --so_epochs 20 --so_batch_size 32 --opt_function MAXUTIL
# or multi meta learner, train multiple meta learner simultaneously # arg ecmp_topo not important
# I'm not sure whether the result is right
python3 /mydata/DOTE/meta_dote.py --ecmp_topo Abilene-squeeze-links-more1 --paths_from sp --so_mode multi-meta-train --so_epochs 20 --so_batch_size 32 --opt_function MAXUTIL

# !! to change the merging approach ## inference the model # "Arnes-1-('7', '23')" "Abilene0-1-('1', '10')"    "Abilene-2-('7', '8')-('9', '10')"  "GEANT"
python3 /mydata/DOTE/meta_dote.py --ecmp_topo "GEANT" --paths_from sp --so_mode meta-test --so_epochs 20 --so_batch_size 16 --opt_function MAXUTIL