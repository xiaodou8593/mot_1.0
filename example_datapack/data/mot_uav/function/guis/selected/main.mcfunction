#mot_uav:guis/selected/main

data modify storage iframe:io inv set from entity @s Inventory
data modify storage iframe:io sel set from entity @s SelectedItem

# 检测GUI发生变动
scoreboard players set update_gui int 0

execute unless data storage iframe:io inv[{Slot:0b}].components."minecraft:custom_data"{button:0b} run scoreboard players set update_gui int 1
execute unless data storage iframe:io inv[{Slot:1b}].components."minecraft:custom_data"{button:1b} run scoreboard players set update_gui int 1
execute unless data storage iframe:io inv[{Slot:2b}].components."minecraft:custom_data"{button:2b} run scoreboard players set update_gui int 1

execute unless data storage iframe:io inv[{Slot:4b}].components."minecraft:custom_data"{button:4b} run scoreboard players set update_gui int 1

execute unless data storage iframe:io inv[{Slot:6b}].components."minecraft:custom_data"{button:6b} run scoreboard players set update_gui int 1
execute unless data storage iframe:io inv[{Slot:7b}].components."minecraft:custom_data"{button:7b} run scoreboard players set update_gui int 1
execute unless data storage iframe:io inv[{Slot:8b}].components."minecraft:custom_data"{button:8b} run scoreboard players set update_gui int 1

execute if score update_gui int matches 1 run function mot_uav:guis/selected/items

# 获取当前无人机编号
function iframe:player_space/_get
execute store result score tempid int run data get storage iframe:io result.mot_uav_id

# 检测无人机是否仍然存在
scoreboard players set res int 0
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int \
	store success score res int run \
	scoreboard players operation tempid int = @s iframe_oid
execute if score res int matches 0 run return run function mot_uav:guis/selected/exit

# 检测玩家是否看向无人机

# 保证玩家已经被初始化为一个时钟周期小于等于3的iframe_ray对象
execute unless entity @s[tag=iframe_ray] run return run function iframe:ray/_prescript_3
execute if score @s iframe_ray_per > 3 int run return run function iframe:ray/_unbe

# 视线追踪返回值为空
execute if score @s iframe_ray_res matches 0 run return run function mot_uav:guis/selected/exit

# 看向的无人机编号不一致
execute unless score tempid int = @s iframe_ray_ptr run return run function mot_uav:guis/selected/exit

# GUI跳转
execute if score @s iframe_crc matches 1 if data storage iframe:io sel.components."minecraft:custom_data"{button:4b} run function mot_uav:guis/selected/to_entered