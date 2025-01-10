#!/bin/bash
cd /mydata/flash/case-2-autoscaling

# 定义文件路径
dir="/mydata/flash/case-2-autoscaling"
files=("adaptation_pool_1.txt" "adaptation_pool_2.txt" "adaptation_pool_3.txt")

# 初始化空的临时文件来存储所有名字
temp_file=$(mktemp)

# 遍历每个文件
for file in "${files[@]}"; do
  filepath="$dir/$file"
  if [[ -f $filepath ]]; then
    # 读取文件中的每行内容，去除 .csv 并存入临时文件
    while IFS= read -r line; do
      name="${line%.csv}"  # 去除 .csv
      echo "$name" >> "$temp_file"
    done < "$filepath"
  else
    echo "File not found: $filepath"
  fi
done

# 去重并保存到最终的列表
name_list=($(sort "$temp_file" | uniq))

# 删除临时文件
rm -f "$temp_file"

# 输出去重后的结果
echo "Unique names:"
printf "%s\n" "${name_list[@]}"

# 遍历 name_list 动态生成目录并执行命令
for name in "${name_list[@]}"; do
  echo "Processing: $name"
  # 创建目录
  mkdir -p ./model/three-ways/"$name"/train-from-scratch/
  mkdir -p ./model/three-ways/"$name"/pretained-test/
  mkdir -p ./model/three-ways/"$name"/continual-learning/
  # 复制文件并运行适应任务
  cp ./model/pretraining-rl/ppo.pth.tar ./model/three-ways/"$name"/continual-learning/ppo_wait_to_adapt.pth.tar
  # cp ./model/pretraining-rl/ppo-ep100.pth.tar ./model/three-ways/"$name"/continual-learning/ppo_wait_to_adapt.pth.tar
done


for name in "${name_list[@]}"; do
  echo "Processing: $name"
  # 运行训练任务
  tmux new-session -d -s tfc-"$name"
  tmux send-keys -t tfc-"$name" "cd /mydata/flash/case-2-autoscaling" C-m
  tmux send-keys -t tfc-"$name" "/mydata/miniconda3/envs/flash/bin/python main.py --operation=train --model_dir=./model/three-ways/$name/train-from-scratch/ --data_path=../data-firm/$name.csv > ./model/three-ways/$name/train-from-scratch/log" C-m
  # python main.py --operation=train --model_dir=./model/three-ways/"$name"/train-from-scratch/ --data_path=../data-firm/"$name".csv > ./model/three-ways/"$name"/train-from-scratch/log

  tmux new-session -d -s cl-"$name"
  tmux send-keys -t cl-"$name" "cd /mydata/flash/case-2-autoscaling" C-m
  tmux send-keys -t cl-"$name" "/mydata/miniconda3/envs/flash/bin/python main.py --operation=adaptation --model_dir=./model --checkpoint_path=./model/three-ways/"$name"/continual-learning/ppo_wait_to_adapt.pth.tar --data_path=../data-firm/$name.csv  > ./model/three-ways/$name/continual-learning/log" C-m
  # python main.py --operation=adaptation --model_dir=./model --checkpoint_path=./model/three-ways/"$name"/continual-learning/ppo_wait_to_adapt.pth.tar --data_path=../data-firm/"$name".csv  > ./model/three-ways/"$name"/continual-learning/log

  # 运行测试任务
  tmux new-session -d -s pt-"$name"
  tmux send-keys -t pt-"$name" "cd /mydata/flash/case-2-autoscaling" C-m
  tmux send-keys -t pt-"$name" "/mydata/miniconda3/envs/flash/bin/python main.py --operation=test --model_dir=./model --checkpoint_path=./model/compress/ppo-ep100.pth.tar --data_path=../data-firm/$name.csv  > ./model/three-ways/$name/pretained-test/log" C-m
  # python main.py --operation=test --model_dir=./model --checkpoint_path=./model/compress/ppo-ep100.pth.tar --data_path=../data-firm/"$name".csv  > ./model/three-ways/"$name"/pretained-test/log
done