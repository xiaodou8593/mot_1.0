#mot_uav:perf/if_block/loop

# 在这里写测试命令
execute at @s if block ~ ~ ~ #mot_uav:pass
execute at @s if block ~ ~1 ~ #mot_uav:pass

scoreboard players remove perf_loop int 1
execute if score perf_loop int matches 1.. run function mot_uav:perf/if_block/loop