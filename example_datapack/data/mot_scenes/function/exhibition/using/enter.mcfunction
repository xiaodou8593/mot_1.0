#mot_scenes:exhibition/using/enter
# 进入使用状态

# 上传使用程序
execute if data storage mot_scenes:io input{slot:"left"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"left_use"}]
execute if data storage mot_scenes:io input{slot:"right"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"right_use"}]
execute if data storage mot_scenes:io input{slot:"down"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"down_use"}]
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_store_program

# 储存使用次数
data modify storage marker_control:io result.use_cnt set from storage mot_scenes:io input.use_cnt

# 状态切换
data modify storage marker_control:io result.state set value "using"