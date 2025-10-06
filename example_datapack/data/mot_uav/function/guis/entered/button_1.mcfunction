#mot_uav:guis/entered/button_1

# 获取无人机
execute store result score tempid int run data get storage iframe:io result.mot_uav_id
scoreboard players set res int 0
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run tag @s add tmp

# 根据按钮状态设置偏移角度
scoreboard players set temp_dtheta int 50000
execute if data storage iframe:io result{button_1:"clockwise"} run scoreboard players operation temp_dtheta int *= -1 int

# 获取无人机当前偏航角
execute as @e[tag=tmp,limit=1] run function mot_uav:_get
execute as 0-0-0-0-0 run function mot_uav:_get_theta

# 维持无人机原高度
scoreboard players operation tempy int = y int
execute if data storage mot_uav:io program.target_y store result score tempy int run data get storage mot_uav:io program.target_y 10000

# 上传无人机上升/下降控制程序
data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"rotation"}]
execute store result storage mot_uav:io program.target_y double 0.0001 run scoreboard players get tempy int
execute store result storage mot_uav:io program.target_theta float 0.0001 run scoreboard players operation theta int += temp_dtheta int
execute as @e[tag=tmp,limit=1] run function mot_uav:_store

tag @e[tag=tmp] remove tmp