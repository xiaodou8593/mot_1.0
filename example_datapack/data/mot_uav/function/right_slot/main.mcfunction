#mot_uav:right_slot/main
# mot_uav:main调用

# 连接确认
scoreboard players set tempid int 0
execute as @e[tag=mot_device] if score @s mot_uav_id = right_slot_id int run scoreboard players operation tempid int = @s mot_uav_root
execute unless score tempid int = @s mot_uav_id run return run scoreboard players set right_slot_id int 0

# 发送姿态同步数据
scoreboard players set u int -2500
scoreboard players set v int 0
scoreboard players set w int 0
function math:uvw/_tovec
execute as @e[tag=mot_device] if score @s mot_uav_id = right_slot_id int run function module_control:_call_method {path:"_sync_coord"}