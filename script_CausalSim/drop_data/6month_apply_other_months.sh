#!/bin/bash

# copy cooked and orig and then generate 
python data_preparation/generate_subset_data.py --dir "CAUSALSIM_DIR-20-11-27 copy/"
python training/train_subset.py --dir "CAUSALSIM_DIR-20-11-27 copy/" --left_out_policy "bola_basic_v2" --C 0.05    # ("bola_basic_v1" "bola_basic_v2" "linear_bba")