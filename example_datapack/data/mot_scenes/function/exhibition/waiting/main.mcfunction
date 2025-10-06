#mot_scenes:exhibition/waiting/main
# mot_scenes:exhibition/main调用

# 检测当前程序运行状态
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_get_program
# 状态结束条件
data modify storage mot_scenes:io temp set from storage mot_uav:io program.list_programs[-1].state
execute if data storage mot_scenes:io {temp:2} run function mot_scenes:exhibition/next_state