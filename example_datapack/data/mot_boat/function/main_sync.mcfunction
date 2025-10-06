#mot_boat:main_sync
# mot_boat:main调用

# 连接确认
data modify storage mot_uav:io slot_type set value "down"
scoreboard players set res int 0
execute as @e[tag=mot_device] if score @s mot_uav_id = mot_uav_root int run function module_control:_call_method {path:"_get_slot_id"}
execute unless score res int = @s mot_uav_id run return run function mot_boat:deconnect

# 栓绳确认
execute if data entity @s leash run return fail
execute at @s run kill @e[type=item,nbt={Item:{id:"minecraft:lead"}},limit=1,sort=nearest]
function mot_boat:deconnect