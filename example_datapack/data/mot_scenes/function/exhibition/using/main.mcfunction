#mot_scenes:exhibition/using/main
# mot_scenes:exhibition/main调用

# 检查使用次数
execute store result score temp_cnt int run data get storage marker_control:io result.use_cnt
execute store result storage marker_control:io result.use_cnt int 1 run scoreboard players remove temp_cnt int 1

# 继续使用设备
execute as @e[tag=mot_uav,limit=1] run function mot_uav:_get_program
data modify storage mot_uav:io program.state set value 1
execute if score temp_cnt int matches ..0 run data modify storage mot_uav:io program.state set value 2
execute as @e[tag=mot_uav,limit=1] run function mot_uav:_store_program

# 状态切换
execute if score temp_cnt int matches ..0 run function mot_scenes:exhibition/next_state