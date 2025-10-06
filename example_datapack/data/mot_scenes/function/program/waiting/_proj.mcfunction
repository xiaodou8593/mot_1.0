#mot_uav:program/waiting/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score state int run data get storage mot_uav:io input.state
execute store result score target_y int run data get storage mot_uav:io input.target_y 10000
execute store result score wait_time int run data get storage mot_uav:io input.wait_time