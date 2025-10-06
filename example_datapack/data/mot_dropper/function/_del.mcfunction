#mot_dropper:_del
# 销毁实体对象
# 输入执行实体

data modify storage mot_uav:io free_addr prepend value 0
execute store result storage mot_uav:io free_addr[0] int 1 run scoreboard players get @s mot_uav_id

execute on passengers run kill @s
kill @s