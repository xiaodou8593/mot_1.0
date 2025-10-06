#mot_boat:_model
# 使用临时对象构建数据模板
# 输出数据模板storage mot_boat:io result

data modify storage mot_boat:io result.mot_uav_root set value 0

execute store result storage mot_boat:io result.mot_uav_root int 1 run scoreboard players get mot_uav_root int