#mot_scenes:exhibition/connecting/enter
# 进入连接状态

# 上传连接程序
execute if data storage mot_scenes:io input{slot:"left"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"left_connect"}]
execute if data storage mot_scenes:io input{slot:"right"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"right_connect"}]
execute if data storage mot_scenes:io input{slot:"down"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"down_connect"}]
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_store_program

# 状态切换
data modify storage marker_control:io result.state set value "connecting"