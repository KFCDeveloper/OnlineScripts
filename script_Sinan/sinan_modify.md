- 修改了 `python3 make_cluster_config.py --nodes ath-8 ath-9 ath-5 --cluster-config test_cluster.json --replica-cpus 4` 的输入参数，因为反正都需要在代码里面去修改 hostname，不如直接这里别输入ath-8 ath-9 ath5 这些了。make_cluster_config.py 里面加了 `nodes = list(IP_ADDR.keys())`

- 要修改ip的地方
    - `/mydata/sinan-local/docker_swarm/config/swarm_ath.json`