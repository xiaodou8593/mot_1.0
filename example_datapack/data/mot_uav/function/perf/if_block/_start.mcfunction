#mot_uav:perf/if_block/_start
# 开始模板测试

# 设置为文件夹名
data modify storage perf:io testing set value "mot_uav:perf/if_block"

# 设置测试环境
setblock 0 0 0 air
setblock 0 1 0 stone
tag @e remove test_as_entity
summon marker 0 0 0 {Tags:["test_as_entity"]}
scoreboard players set @e[tag=test_as_entity,limit=1] killtime 25

# 设置开始测试延后时间(防止上一步消耗过大使tps波动)
scoreboard players set perf_start int 10

# 设置测试次数(测试多少个tick)
scoreboard players set perf_cnt int 10

# 设置单次测试递归次数(值必须整除10000000)
scoreboard players set perf_n int 1000000