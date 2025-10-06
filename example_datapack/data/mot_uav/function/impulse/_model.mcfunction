#mot_uav:impulse/_model
# 构建冲量的数据模板
# 输出数据模板storage mot_uav:io result

data modify storage mot_uav:io result set value {vector:[0.0d,0.0d,0.0d], point:[0.0d,0.0d,0.0d]}

execute store result storage mot_uav:io result.vector[0] double 0.0001 run scoreboard players get impulse_fx int
execute store result storage mot_uav:io result.vector[1] double 0.0001 run scoreboard players get impulse_fy int
execute store result storage mot_uav:io result.vector[2] double 0.0001 run scoreboard players get impulse_fz int
execute store result storage mot_uav:io result.point[0] double 0.0001 run scoreboard players get impulse_x int
execute store result storage mot_uav:io result.point[1] double 0.0001 run scoreboard players get impulse_y int
execute store result storage mot_uav:io result.point[2] double 0.0001 run scoreboard players get impulse_z int