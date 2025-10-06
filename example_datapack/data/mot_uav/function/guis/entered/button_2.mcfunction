#mot_uav:guis/entered/button_2

# 获取无人机
execute store result score tempid int run data get storage iframe:io result.mot_uav_id
scoreboard players set res int 0
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run tag @s add tmp
execute as @e[tag=tmp,limit=1] run function mot_uav:_get

# 维持无人机原高度
scoreboard players operation tempy int = y int
execute if data storage mot_uav:io program.target_y store result score tempy int run data get storage mot_uav:io program.target_y 10000

# 上传位移程序
data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"position"}]
execute store result storage mot_uav:io program.target_y double 0.0001 run scoreboard players get tempy int
scoreboard players operation tempx int = kvec_x int
scoreboard players operation tempz int = kvec_z int
scoreboard players operation tempx int *= 2 int
scoreboard players operation tempz int *= 2 int
execute store result storage mot_uav:io program.target_pos[0] double 0.0001 run scoreboard players operation tempx int += x int
execute store result storage mot_uav:io program.target_pos[1] double 0.0001 run scoreboard players get tempy int
execute store result storage mot_uav:io program.target_pos[2] double 0.0001 run scoreboard players operation tempz int += z int
execute as @e[tag=tmp,limit=1] run function mot_uav:_store

tag @e[tag=tmp] remove tmp