#mot_boat:_sync_request

# 不支持左右插口
execute unless data storage mot_uav:io {slot_type:"down"} run return run scoreboard players set res int 0

# 采用默认实现
function mot_uav:device/_sync_request

# 栓绳连接
scoreboard players operation tempid int = @s mot_uav_root
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run data modify storage mot_boat:io temp_uuid set from entity @s UUID
execute if score res int matches 1.. run data modify entity @s leash.UUID set from storage mot_boat:io temp_uuid