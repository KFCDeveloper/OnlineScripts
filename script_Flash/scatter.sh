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

# mkdir -p ./model/three-ways/readfile_sleep_imageresize_output/train-from-scratch/
# python main.py --operation=train --model_dir=./model/three-ways/readfile_sleep_imageresize_output/train-from-scratch/ --data_path=../data-firm/readfile_sleep_imageresize_output.csv > ./model/three-ways/readfile_sleep_imageresize_output/train-from-scratch/log

# # ppo_wait_to_adapt.pth.tar 复制到每个文件夹里
# mkdir -p ./model/three-ways/readfile_sleep_imageresize_output/continual-learning/
# cp ./model/compress/ppo-ep100.pth.tar ./model/three-ways/readfile_sleep_imageresize_output/continual-learning/ppo_wait_to_adapt.pth.tar
# python main.py --operation=adaptation --model_dir=./model --checkpoint_path=./model/three-ways/readfile_sleep_imageresize_output/continual-learning/ppo_wait_to_adapt.pth.tar --data_path=../data-firm/readfile_sleep_imageresize_output.csv > ./model/three-ways/readfile_sleep_imageresize_output/continual-learning/log

# mkdir -p ./model/three-ways/readfile_sleep_imageresize_output/pretained-test/
# python main.py --operation=test --model_dir=./model --checkpoint_path=./model/compress/ppo-ep100.pth.tar --data_path=../data-firm/readfile_sleep_imageresize_output.csv > ./model/three-ways/readfile_sleep_imageresize_output/pretained-test/log