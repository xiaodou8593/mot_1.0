#mot_scatter:_store
# 临时对象赋值到实体对象
# 输入执行实体

scoreboard players operation @s scatter_phi = scatter_phi int
scoreboard players operation @s bullet_res = bullet_res int
data modify entity @s item.components."minecraft:custom_data".slot_type set from storage mot_uav:io slot_type
scoreboard players operation @s mot_uav_root = mot_uav_root int
scoreboard players operation @s motion_static = motion_static int
data modify entity @s item.components."minecraft:custom_data".list_impulse set from storage mot_uav:io list_impulse
scoreboard players operation @s vx = vx int
scoreboard players operation @s vy = vy int
scoreboard players operation @s vz = vz int
scoreboard players operation @s angular_x = angular_x int
scoreboard players operation @s angular_y = angular_y int
scoreboard players operation @s angular_z = angular_z int
scoreboard players operation @s angular_len = angular_len int
scoreboard players operation @s x = x int
scoreboard players operation @s y = y int
scoreboard players operation @s z = z int
scoreboard players operation @s ivec_x = ivec_x int
scoreboard players operation @s ivec_y = ivec_y int
scoreboard players operation @s ivec_z = ivec_z int
scoreboard players operation @s jvec_x = jvec_x int
scoreboard players operation @s jvec_y = jvec_y int
scoreboard players operation @s jvec_z = jvec_z int
scoreboard players operation @s kvec_x = kvec_x int
scoreboard players operation @s kvec_y = kvec_y int
scoreboard players operation @s kvec_z = kvec_z int
scoreboard players operation @s quat_x = quat_x int
scoreboard players operation @s quat_y = quat_y int
scoreboard players operation @s quat_z = quat_z int
scoreboard players operation @s quat_w = quat_w int
scoreboard players operation @s quat_start_x = quat_start_x int
scoreboard players operation @s quat_start_y = quat_start_y int
scoreboard players operation @s quat_start_z = quat_start_z int
scoreboard players operation @s quat_start_w = quat_start_w int
scoreboard players operation @s quat_orth_x = quat_orth_x int
scoreboard players operation @s quat_orth_y = quat_orth_y int
scoreboard players operation @s quat_orth_z = quat_orth_z int
scoreboard players operation @s quat_orth_w = quat_orth_w int
scoreboard players operation @s quat_phi = quat_phi int