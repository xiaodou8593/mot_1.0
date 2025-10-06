#mot_scenes:exhibition/deconnecting/enter
# 进入断连状态

# 上传断连程序
execute if data storage mot_scenes:io input{slot:"left"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"left_deconnect"}]
execute if data storage mot_scenes:io input{slot:"right"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"right_deconnect"}]
execute if data storage mot_scenes:io input{slot:"down"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"down_deconnect"}]
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_store_program

# 状态切换
data modify storage marker_control:io result.state set value "deconnecting"