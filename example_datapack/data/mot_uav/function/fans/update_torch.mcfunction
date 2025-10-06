#mot_uav:fans/update_torch
# mot_uav:fans/_on调用
# mot_uav:fans/_off调用
# mot_uav:fans/_update调用
# mot_uav:set_operations调用

data modify storage mot_uav:io temp set value "false"
execute if score @s fans_power matches 1.. run data modify storage mot_uav:io temp set value "true"

execute on passengers if entity @s[tag=torch] run \
	data modify entity @s block_state.Properties.lit set from storage mot_uav:io temp

execute if data storage mot_uav:io {temp:"true"} on passengers if entity @s[tag=torch] run \
	data modify entity @s brightness set value {sky:15, block:15}

execute if data storage mot_uav:io {temp:"false"} on passengers if entity @s[tag=torch] run \
	data remove entity @s brightness

execute if score @s fans_power matches 0 run data modify entity @s item.components."minecraft:custom_data".program.state set value 0
execute if score @s fans_power matches 0 run function mot_uav:_unload_all_devices