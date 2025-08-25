#!/bin/bash
# some error: not source ~/.bashrc(no env variable); not activate dote;
# /mydata/DOTE/networking_envs/data/loop_gen_task_3edges.sh > /mydata/DOTE/networking_envs/data/gen_log/3edges.log
# conda activate dote

# 运行脚本：
# cd /mydata/DOTE/networking_envs/data/
#./loop_gen_task_3edges.sh
# 监控进度：
# tmux attach-session -t 3edges_parallel_[进程ID]_[任务ID]
# 查看所有会话：
# tmux list-sessions | grep 3edges_parallel

# 
edges=("('0', '1')" "('0', '2')" "('1', '10')" "('2', '9')" "('3', '4')" "('3', '6')" "('4', '5')" "('4', '6')" "('5', '8')" "('6', '7')" "('7', '8')" "('7', '10')" "('8', '9')" "('9', '10')")

# Create a unique base session name
base_session_name="3edges_parallel_$$"

# Generate all possible combinations of 3 edges
combinations=()
for ((i=0; i<${#edges[@]}-2; i++)); do
    for ((j=i+1; j<${#edges[@]}-1; j++)); do
        for ((k=j+1; k<${#edges[@]}; k++)); do
            combinations+=("$i $j $k")
        done
    done
done

# Shuffle the combinations to randomize the order
IFS=$'\n' shuffled_combinations=($(shuf -e "${combinations[@]}"))
unset IFS

echo "Total combinations to process: ${#shuffled_combinations[@]}"

# Process each combination
for idx in "${!shuffled_combinations[@]}"; do
    # Parse the combination
    read -r i j k <<< "${shuffled_combinations[idx]}"
    
    # Create a unique session name for each task
    session_name="${base_session_name}_${idx}"
    
    # Print progress
    echo "Creating session $((idx+1))/${#shuffled_combinations[@]} - Session: $session_name (edges: ${edges[i]}, ${edges[j]}, ${edges[k]})"
    
    # Create new tmux session for each task
    tmux new-session -d -s "$session_name" "bash -c 'cd /mydata/DOTE/networking_envs/data/ && /mydata/miniconda3/envs/dote/bin/python loop_gml_to_dote_3lines-obj2.py \"Abilene\" '\''${edges[i]}'\'' '\''${edges[j]}'\'' '\''${edges[k]}'\'' && cd \"/mydata/DOTE/networking_envs/data/Abilene-obj1-3-${edges[i]}-${edges[j]}-${edges[k]}\" && /mydata/miniconda3/envs/dote/bin/python /mydata/DOTE/networking_envs/data/loop_compute_opts.py \"Abilene-obj1-3-${edges[i]}-${edges[j]}-${edges[k]}\"; exec bash'"
    
    # Small delay to avoid overwhelming the system
    sleep 0.1
done

echo "All tasks started in separate tmux sessions with base name: $base_session_name"
echo "Use 'tmux list-sessions | grep $base_session_name' to see all running sessions"
echo "Use 'tmux attach-session -t [session_name]' to monitor individual tasks"
