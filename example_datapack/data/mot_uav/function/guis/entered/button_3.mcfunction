#mot_uav:guis/entered/button_3

# 生成旗帜
execute at @s anchored eyes positioned ^ ^ ^ as 0-0-0-0-0 run function mot_uav:guis/entered/summon_banner
execute if score iframe_ray_res int matches 0 run return run scoreboard players set update_gui int 1

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
data modify storage mot_uav:io program.target_pos set from entity @e[tag=result,limit=1] Pos
execute store result storage mot_uav:io program.target_pos[1] double 0.0001 run scoreboard players get tempy int
execute as @e[tag=tmp,limit=1] run function mot_uav:_store

tag @e[tag=tmp] remove tmp

scoreboard players set update_gui int 1

execute at @s run playsound minecraft:block.grass.break player @s ~ ~ ~ 1.0 1.0