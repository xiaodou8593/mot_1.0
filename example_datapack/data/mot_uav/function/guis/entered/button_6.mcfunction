#mot_uav:guis/entered/button_6

# 获取左插槽设备
execute store result score tempid int run data get storage iframe:io result.mot_uav_id
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run scoreboard players operation tempid int = @s right_slot_id
execute as @e[tag=mot_device] if score @s mot_uav_id = tempid int run tag @s add tmp
execute unless entity @e[tag=tmp,limit=1] run return run scoreboard players set update_gui int 1

scoreboard players set res int 1
execute as @e[tag=tmp,limit=1] run function module_control:_call_method {path:"_use_signal"}
execute if score res int matches 1 run scoreboard players set update_gui int 1

tag @e[tag=tmp] remove tmp