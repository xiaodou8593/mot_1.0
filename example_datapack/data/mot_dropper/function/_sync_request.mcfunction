#mot_dropper:_sync_request

# 不支持左右插口
execute unless data storage mot_uav:io {slot_type:"down"} run return run scoreboard players set res int 0

# 采用默认实现
function mot_uav:device/_sync_request