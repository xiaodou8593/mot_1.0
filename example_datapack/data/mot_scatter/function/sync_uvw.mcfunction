#mot_scatter:sync_uvw
# mot_scatter:main调用

scoreboard players set mot_sync_u int 0
scoreboard players set mot_sync_v int 1250
scoreboard players set mot_sync_w int 0

execute if data storage mot_uav:io {slot_type:"left"} run scoreboard players set mot_sync_u int -3750
execute if data storage mot_uav:io {slot_type:"down"} run scoreboard players set mot_sync_v int 3750
execute if data storage mot_uav:io {slot_type:"right"} run scoreboard players set mot_sync_u int 3750

# 设置完成
return 1