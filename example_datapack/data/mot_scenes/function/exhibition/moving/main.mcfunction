#mot_scenes:exhibition/moving/enter
# mot_scenes:exhibition/main调用

# 检测当前程序运行状态
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_get_program
# 状态结束条件
execute unless data storage mot_uav:io program{state:1} run function mot_scenes:exhibition/next_state