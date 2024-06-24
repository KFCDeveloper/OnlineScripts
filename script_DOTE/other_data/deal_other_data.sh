
cd /mydata/software/GEANT
wget https://sndlib.put.poznan.pl/download/directed-geant-uhlig-15min-over-4months-ALL-native.tgz
# 数据从 前两个也是空数据  ，并且从 demandMatrix-geant-uhlig-15min-20050831-0800.txt 开始就是空的了 要剔除；直接剔除行数小于100行的
# 在画trend的时候又可以不用剔除了，为0的就设置为 Nan，画线会跳过。

### GEANT
cd /mydata/DOTE/networking_envs/data
wget https://sndlib.put.poznan.pl/download/directed-geant-uhlig-15min-over-4months-ALL-native.tgz
chmod 777 directed-geant-uhlig-15min-over-4months-ALL-native.tgz
tar -zxvf directed-geant-uhlig-15min-over-4months-ALL-native.tgz
rm directed-geant-uhlig-15min-over-4months-ALL-native.tgz
mv directed-geant-uhlig-15min-over-4months-ALL-native GEANT
/mydata/miniconda3/envs/dote/bin/python /mydata/DOTE/networking_envs/data/gen_geant_topo.py # gen_geant_topo.py
cd /mydata/DOTE/networking_envs/data/GEANT

conda activate dote
pip install joblib
cd "/mydata/DOTE/networking_envs/data/GEANT"
/mydata/miniconda3/envs/dote/bin/python /mydata/DOTE/networking_envs/data/loop_compute_opts.py "GEANT"

# train
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt update
sudo apt install gcc-9 -y
sudo apt install libstdc++6 -y
cd /mydata/DOTE/networking_envs/save_models
python3 /mydata/DOTE/dote.py --ecmp_topo "Abilene-2-('7', '8')-('9', '10')" --paths_from sp --so_mode train-fixdimen --so_epochs 20 --so_batch_size 16 --opt_function MAXUTIL

# test
python3 /mydata/DOTE/dote.py --ecmp_topo "GEANT" --paths_from sp --so_mode test-fixdimen --so_epochs 20 --so_batch_size 16 --opt_function MAXUTIL


### Brain
cd /mydata/DOTE/real_traffic/download_data/Brain/one_year
wget https://sndlib.put.poznan.pl/download/directed-brain-1h-over-375day-native.tgz
chmod 777 directed-brain-1h-over-375day-native.tgz
tar -zxvf directed-brain-1h-over-375day-native.tgz
rm directed-brain-1h-over-375day-native.tgz
mv directed-geant-uhlig-15min-over-4months-ALL-native GEANT

cd /mydata/DOTE/networking_envs/data
wget https://sndlib.put.poznan.pl/download/directed-geant-uhlig-15min-over-4months-ALL-native.tgz
chmod 777 directed-geant-uhlig-15min-over-4months-ALL-native.tgz
tar -zxvf directed-geant-uhlig-15min-over-4months-ALL-native.tgz
rm directed-geant-uhlig-15min-over-4months-ALL-native.tgz
mv directed-geant-uhlig-15min-over-4months-ALL-native GEANT
/mydata/miniconda3/envs/dote/bin/python /mydata/DOTE/networking_envs/data/gen_geant_topo.py # gen_geant_topo.py
cd /mydata/DOTE/networking_envs/data/GEANT

conda activate dote
pip install joblib
/mydata/miniconda3/envs/dote/bin/python /mydata/DOTE/networking_envs/data/loop_compute_opts.py "GEANT"

# train
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt update
sudo apt install gcc-9 -y
sudo apt install libstdc++6 -y
cd /mydata/DOTE/networking_envs/save_models
python3 /mydata/DOTE/dote.py --ecmp_topo "Abilene-2-('7', '8')-('9', '10')" --paths_from sp --so_mode train-fixdimen --so_epochs 20 --so_batch_size 16 --opt_function MAXUTIL

# test
python3 /mydata/DOTE/dote.py --ecmp_topo "GEANT" --paths_from sp --so_mode test-fixdimen --so_epochs 20 --so_batch_size 16 --opt_function MAXUTIL