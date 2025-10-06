#mot_scenes:exhibition/connecting/main
# mot_scenes:exhibition/main调用

# 连接成功则状态跳转
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_get_program
execute if data storage mot_uav:io program{state:2} run return run function mot_scenes:exhibition/next_state

# 尝试重新连接
data modify storage mot_uav:io program.state set value 1
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_store_program