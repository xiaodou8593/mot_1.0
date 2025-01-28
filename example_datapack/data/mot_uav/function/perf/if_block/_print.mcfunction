#mot_uav:perf/if_block/_print
# 输出测试数据

data modify storage perf:io temp set from storage perf:class mot_uav:perf/if_block

tellraw @a "--- mot_uav:perf/if_block perf result ---"

execute store result score perf_cnt int run data get storage perf:io temp.cnt
execute store result score perf_n int run data get storage perf:io temp.n
tellraw @a ["cnt: ",{"score":{"name":"perf_cnt","objective":"int"}},"    n: ",{"score":{"name":"perf_n","objective":"int"}}]

execute store result score perf_min int run data get storage perf:io temp.min
execute store result score perf_max int run data get storage perf:io temp.max
tellraw @a ["min: ",{"score":{"name":"perf_min","objective":"int"}},"    max: ",{"score":{"name":"perf_max","objective":"int"}}]

execute store result score perf_avg int run data get storage perf:io temp.avg
scoreboard players operation perf_err int = perf_max int
scoreboard players operation perf_err int -= perf_avg int
scoreboard players operation sstemp int = perf_avg int
scoreboard players operation sstemp int -= perf_min int
scoreboard players operation perf_err int > sstemp int
scoreboard players operation perf_err int *= 100 int
scoreboard players operation perf_err int /= perf_avg int
tellraw @a ["avg: ",{"score":{"name":"perf_avg","objective":"int"}},"    err: ",{"score":{"name":"perf_err","objective":"int"}},"%"]

scoreboard players operation perf_scb_add int = perf_avg int
scoreboard players set sstemp int 10000000
scoreboard players operation sstemp int /= perf_n int
scoreboard players operation perf_scb_add int *= sstemp int
execute store result score sstemp0 int run data get storage perf:class base.avg
execute store result score sstemp1 int run data get storage perf:class scb_add.avg
scoreboard players operation sstemp1 int -= sstemp0 int
scoreboard players operation perf_scb_add int -= sstemp0 int
scoreboard players operation perf_scb_add int *= 100 int
scoreboard players operation perf_scb_add int /= sstemp1 int
scoreboard players operation sstemp int = perf_scb_add int
scoreboard players operation perf_scb_add int /= 100 int
scoreboard players operation sstemp int %= 100 int
execute if score sstemp int matches 10..99 run tellraw @a ["scb_add: ",{"score":{"name":"perf_scb_add","objective":"int"}},".",{"score":{"name":"sstemp","objective":"int"}}]
execute if score sstemp int matches 0..9 run tellraw @a ["scb_add: ",{"score":{"name":"perf_scb_add","objective":"int"}},".0",{"score":{"name":"sstemp","objective":"int"}}]

# 超过阈值重测
execute if score perf_err int <= perf_check int run return 0
tellraw @a "mot_uav:perf/if_block perf restart"
data modify storage perf:io afk prepend value "mot_uav:perf/if_block"