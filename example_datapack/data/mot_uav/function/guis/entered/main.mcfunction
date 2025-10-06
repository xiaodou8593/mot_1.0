#mot_uav:guis/entered/main

# 避免连接冲突
scoreboard players operation tempid int = @s mot_uav_using
scoreboard players set res int 0
execute as @a if score @s mot_uav_using = tempid int run scoreboard players add res int 1
execute if score res int matches 2.. run return run function mot_uav:guis/entered/exit_conflict

data modify storage iframe:io inv set from entity @s Inventory

# 获取玩家空间
function iframe:player_space/_get

# 检测无人机是否失联
execute store result score tempid int run data get storage iframe:io result.mot_uav_id
scoreboard players set res int 0
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run scoreboard players set res int 1
execute if score res int matches 0 run return run function mot_uav:guis/entered/exit_error

# 连接显示
title @s actionbar [{"text":"已连接到mot_uav_","color":"green"},{"score":{"name":"tempid","objective":"int"}}]

# 检测GUI发生变动
scoreboard players set update_gui int 0

execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:0b} run function mot_uav:guis/entered/s_up_down
execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:1b} run function mot_uav:guis/entered/s_clockwise
execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:2b} run scoreboard players set update_gui int 1
execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:3b} run function mot_uav:guis/entered/button_3
execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:4b} run function mot_uav:guis/entered/left_q
execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:5b} run function mot_uav:guis/entered/down_q
execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:6b} run function mot_uav:guis/entered/right_q
execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:7b} run function mot_uav:guis/entered/s_on_off
execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:8b} run return run function mot_uav:guis/entered/exit

execute if data storage iframe:io inv[{Slot:-106b}].components."minecraft:custom_data"{button:0b} run function mot_uav:guis/entered/button_0
execute if data storage iframe:io inv[{Slot:-106b}].components."minecraft:custom_data"{button:1b} run function mot_uav:guis/entered/button_1
execute if data storage iframe:io inv[{Slot:-106b}].components."minecraft:custom_data"{button:2b} run function mot_uav:guis/entered/button_2
execute if data storage iframe:io inv[{Slot:-106b}].components."minecraft:custom_data"{button:4b} run function mot_uav:guis/entered/button_4
execute if data storage iframe:io inv[{Slot:-106b}].components."minecraft:custom_data"{button:5b} run function mot_uav:guis/entered/button_5
execute if data storage iframe:io inv[{Slot:-106b}].components."minecraft:custom_data"{button:6b} run function mot_uav:guis/entered/button_6

execute if score update_gui int matches 1 run function mot_uav:guis/entered/items