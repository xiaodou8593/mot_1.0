#mot_uav:guis/entered/right_q

# 获取无人机
execute store result score tempid int run data get storage iframe:io result.mot_uav_id
scoreboard players set res int 0
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run tag @s add tmp

# 根据right_slot状态上传程序
execute as @e[tag=tmp,limit=1] run function mot_uav:_get
execute if score right_slot_id int matches 0 run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"right_connect"}]
execute if score right_slot_id int matches 1.. run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"right_deconnect"}]
execute as @e[tag=tmp,limit=1] run function mot_uav:_store

tag @e[tag=tmp] remove tmp

scoreboard players set update_gui int 1