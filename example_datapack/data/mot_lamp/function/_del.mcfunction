#mot_lamp:_del
# 销毁实例

data modify storage mot_uav:io free_addr prepend value 0
execute store result storage mot_uav:io free_addr[0] int 1 run scoreboard players get @s mot_uav_id

execute on passengers run kill @s
kill @s