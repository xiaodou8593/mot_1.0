#mot_uav:program/up/_model
# 使用临时对象构建数据模板
# 输出[storage mot_uav:io result]

data modify storage mot_uav:io result set value {delta_y:0.0d ,pointer:"", target_y:0.0d, damp_params:[0.0d,0.0d,0.0d], state:0}

execute store result storage mot_uav:io result.delta_y double 0.0001 run scoreboard players get delta_y int
data modify storage mot_uav:io result.pointer set from storage mot_uav:io ptr
execute store result storage mot_uav:io result.target_y double 0.0001 run scoreboard players get target_y int
execute store result storage mot_uav:io result.damp_params[0] double 0.0001 run scoreboard players get damp_k int
execute store result storage mot_uav:io result.damp_params[1] double 0.0001 run scoreboard players get damp_b int
execute store result storage mot_uav:io result.damp_params[2] double 0.0001 run scoreboard players get damp_f int
execute store result storage mot_uav:io result.state int 1 run scoreboard players get state int