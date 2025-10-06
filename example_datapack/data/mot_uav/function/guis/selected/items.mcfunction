#mot_uav:guis/selected/items

clear @s

# 填充GUI物品
item replace entity @s hotbar.0 with blue_stained_glass_pane[minecraft:custom_data={iframe_ui:1b,button:0b},minecraft:custom_name='{"text":""}']
item replace entity @s hotbar.1 with blue_stained_glass_pane[minecraft:custom_data={iframe_ui:1b,button:1b},minecraft:custom_name='{"text":""}']
item replace entity @s hotbar.2 with blue_stained_glass_pane[minecraft:custom_data={iframe_ui:1b,button:2b},minecraft:custom_name='{"text":""}']

item replace entity @s hotbar.6 with blue_stained_glass_pane[minecraft:custom_data={iframe_ui:1b,button:6b},minecraft:custom_name='{"text":""}']
item replace entity @s hotbar.7 with blue_stained_glass_pane[minecraft:custom_data={iframe_ui:1b,button:7b},minecraft:custom_name='{"text":""}']
item replace entity @s hotbar.8 with blue_stained_glass_pane[minecraft:custom_data={iframe_ui:1b,button:8b},minecraft:custom_name='{"text":""}']

item replace entity 0-0-0-0-2 contents with comparator[minecraft:custom_data={iframe_ui:1b,button:4b},minecraft:consumable={consume_seconds:1024f}]
function iframe:player_space/_get
execute store result score tempid int run data get storage iframe:io result.mot_uav_id
data modify storage mot_uav:io input set value '[{"text":"enter mot_uav_","color":"red","italic":false},{"score":{"name":"tempid","objective":"int"}}]'
item modify entity 0-0-0-0-1 container.0 mot_uav:_interpret
data modify entity 0-0-0-0-2 item.components."minecraft:custom_name" set from entity 0-0-0-0-1 Item.components."minecraft:lore"[0]
item replace entity @s hotbar.4 from entity 0-0-0-0-2 contents