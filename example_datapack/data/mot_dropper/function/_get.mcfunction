#mot_dropper:_get
# 实体对象赋值到临时对象
# 输入执行实体

data modify storage mot_mover:io block_id set from entity @s item.components."minecraft:custom_data".block_id
data modify storage mot_mover:io block_state set from entity @s item.components."minecraft:custom_data".block_state
data modify storage mot_mover:io block_nbt set from entity @s item.components."minecraft:custom_data".block_nbt
data modify storage mot_uav:io slot_type set from entity @s item.components."minecraft:custom_data".slot_type
scoreboard players operation mot_uav_root int = @s mot_uav_root
scoreboard players operation motion_static int = @s motion_static
data modify storage mot_uav:io list_impulse set from entity @s item.components."minecraft:custom_data".list_impulse
scoreboard players operation vx int = @s vx
scoreboard players operation vy int = @s vy
scoreboard players operation vz int = @s vz
scoreboard players operation angular_x int = @s angular_x
scoreboard players operation angular_y int = @s angular_y
scoreboard players operation angular_z int = @s angular_z
scoreboard players operation angular_len int = @s angular_len
scoreboard players operation x int = @s x
scoreboard players operation y int = @s y
scoreboard players operation z int = @s z
scoreboard players operation ivec_x int = @s ivec_x
scoreboard players operation ivec_y int = @s ivec_y
scoreboard players operation ivec_z int = @s ivec_z
scoreboard players operation jvec_x int = @s jvec_x
scoreboard players operation jvec_y int = @s jvec_y
scoreboard players operation jvec_z int = @s jvec_z
scoreboard players operation kvec_x int = @s kvec_x
scoreboard players operation kvec_y int = @s kvec_y
scoreboard players operation kvec_z int = @s kvec_z
scoreboard players operation quat_x int = @s quat_x
scoreboard players operation quat_y int = @s quat_y
scoreboard players operation quat_z int = @s quat_z
scoreboard players operation quat_w int = @s quat_w
scoreboard players operation quat_start_x int = @s quat_start_x
scoreboard players operation quat_start_y int = @s quat_start_y
scoreboard players operation quat_start_z int = @s quat_start_z
scoreboard players operation quat_start_w int = @s quat_start_w
scoreboard players operation quat_orth_x int = @s quat_orth_x
scoreboard players operation quat_orth_y int = @s quat_orth_y
scoreboard players operation quat_orth_z int = @s quat_orth_z
scoreboard players operation quat_orth_w int = @s quat_orth_w
scoreboard players operation quat_phi int = @s quat_phi