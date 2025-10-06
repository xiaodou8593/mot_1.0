#mot_uav:new_addr
# mot_uav:_new_id调用

data modify storage mot_uav:io free_addr prepend value 0
execute store result storage mot_uav:io free_addr[0] int 1 run scoreboard players add #id mot_uav_id 1