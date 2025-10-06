#mot_uav:guis/entered/items

clear @s

# 填充GUI物品
execute if data storage iframe:io result{button_0:"up"} run \
	item replace entity @s hotbar.0 with firework_rocket[minecraft:custom_data={iframe_ui:1b,button:0b},minecraft:custom_name='{"text":"up","color":"red"}']
execute if data storage iframe:io result{button_0:"down"} run \
	item replace entity @s hotbar.0 with anvil[minecraft:custom_data={iframe_ui:1b,button:0b},minecraft:custom_name='{"text":"down","color":"red"}']

execute if data storage iframe:io result{button_1:"counterclockwise"} run \
	item replace entity @s hotbar.1 with light_blue_carpet[minecraft:custom_data={iframe_ui:1b,button:1b},minecraft:custom_name='{"text":"counterclockwise","color":"red"}']
execute if data storage iframe:io result{button_1:"clockwise"} run \
	item replace entity @s hotbar.1 with magenta_carpet[minecraft:custom_data={iframe_ui:1b,button:1b},minecraft:custom_name='{"text":"clockwise","color":"red"}']

execute store result score tempid int run data get storage iframe:io result.mot_uav_id
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run scoreboard players operation fans_power int = @s fans_power
execute if score fans_power int matches 0 run \
	item replace entity @s hotbar.7 with lever[minecraft:custom_data={iframe_ui:1b,button:7b},minecraft:custom_name='{"text":"on","color":"red"}']
execute if score fans_power int matches 1.. run \
	item replace entity @s hotbar.7 with redstone_torch[minecraft:custom_data={iframe_ui:1b,button:7b},minecraft:custom_name='{"text":"off","color":"red"}']

item replace entity @s hotbar.8 with barrier[minecraft:custom_data={iframe_ui:1b,button:8b},minecraft:custom_name='{"text":"exit","color":"red"}']

item replace entity @s hotbar.2 with arrow[minecraft:custom_data={iframe_ui:1b,button:2b},minecraft:custom_name='{"text":"forward","color":"red"}']
item replace entity @s hotbar.3 with red_banner[minecraft:custom_data={iframe_ui:1b,button:3b},minecraft:custom_name='{"text":"position","color":"red"}']

item replace entity @s hotbar.4 with heavy_weighted_pressure_plate[minecraft:custom_data={iframe_ui:1b,button:4b},minecraft:custom_name='{"text":"left_device","color":"red"}']
item replace entity @s hotbar.5 with heavy_weighted_pressure_plate[minecraft:custom_data={iframe_ui:1b,button:5b},minecraft:custom_name='{"text":"down_device","color":"red"}']
item replace entity @s hotbar.6 with heavy_weighted_pressure_plate[minecraft:custom_data={iframe_ui:1b,button:6b},minecraft:custom_name='{"text":"right_device","color":"red"}']