- 修改了 `python3 make_cluster_config.py --nodes ath-8 ath-9 ath-5 --cluster-config test_cluster.json --replica-cpus 4` 的输入参数，因为反正都需要在代码里面去修改 hostname，不如直接这里别输入ath-8 ath-9 ath5 这些了。make_cluster_config.py 里面加了 `nodes = list(IP_ADDR.keys())`

- 要修改ip的地方（这个 `swarm_ath.json` 应该可以用来作为全局读取ip的文件）
    - `/mydata/sinan-local/docker_swarm/config/swarm_ath.json`
- 中间在collect data的时候，总是报 0.0.0.0:8080 连不上，我改成了 `addr = "http://localhost:8080"`，就不报错了，不知原因。
- 22点00分 突然就fail了。去看了docker守备进程的报错，发现镜像根本没有拉取；于是去手动拉取镜像，发现超过拉取次数了，然后登录解决 [stackoverflow](https://stackoverflow.com/questions/65806330/toomanyrequests-you-have-reached-your-pull-rate-limit-you-may-increase-the-lim)  `sudo docker login --username=pinkwinston`
