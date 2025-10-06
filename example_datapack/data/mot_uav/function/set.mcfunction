#mot_uav:set
# mot_uav:_new调用

execute store result score @s left_slot_id run data get storage mot_uav:io input.left_slot_id
execute store result score @s down_slot_id run data get storage mot_uav:io input.down_slot_id
execute store result score @s right_slot_id run data get storage mot_uav:io input.right_slot_id
data modify entity @s item.components."minecraft:custom_data".program set from storage mot_uav:io input.program
execute store result score @s fans_power run data get storage mot_uav:io input.fans[0] 10000
execute store result score @s fans_theta run data get storage mot_uav:io input.fans[1] 10000
execute store result score @s fans_timer run data get storage mot_uav:io input.fans[2] 10000
execute store result score @s motion_static run data get storage mot_uav:io input.motion_static
data modify entity @s item.components."minecraft:custom_data".list_impulse set from storage mot_uav:io input.list_impulse
execute store result score @s vx run data get storage mot_uav:io input.velocity[0] 10000
execute store result score @s vy run data get storage mot_uav:io input.velocity[1] 10000
execute store result score @s vz run data get storage mot_uav:io input.velocity[2] 10000
execute store result score @s angular_x run data get storage mot_uav:io input.angular_vec[0] 10000
execute store result score @s angular_y run data get storage mot_uav:io input.angular_vec[1] 10000
execute store result score @s angular_z run data get storage mot_uav:io input.angular_vec[2] 10000
execute store result score @s angular_len run data get storage mot_uav:io input.angular_len 10000
execute store result score @s x run data get storage mot_uav:io input.position[0] 10000
execute store result score @s y run data get storage mot_uav:io input.position[1] 10000
execute store result score @s z run data get storage mot_uav:io input.position[2] 10000
execute store result score @s ivec_x run data get storage mot_uav:io input.ivec[0] 10000
execute store result score @s ivec_y run data get storage mot_uav:io input.ivec[1] 10000
execute store result score @s ivec_z run data get storage mot_uav:io input.ivec[2] 10000
execute store result score @s jvec_x run data get storage mot_uav:io input.jvec[0] 10000
execute store result score @s jvec_y run data get storage mot_uav:io input.jvec[1] 10000
execute store result score @s jvec_z run data get storage mot_uav:io input.jvec[2] 10000
execute store result score @s kvec_x run data get storage mot_uav:io input.kvec[0] 10000
execute store result score @s kvec_y run data get storage mot_uav:io input.kvec[1] 10000
execute store result score @s kvec_z run data get storage mot_uav:io input.kvec[2] 10000
execute store result score @s quat_x run data get storage mot_uav:io input.xyzw[0] 10000
execute store result score @s quat_y run data get storage mot_uav:io input.xyzw[1] 10000
execute store result score @s quat_z run data get storage mot_uav:io input.xyzw[2] 10000
execute store result score @s quat_w run data get storage mot_uav:io input.xyzw[3] 10000
execute store result score @s quat_start_x run data get storage mot_uav:io input.start_xyzw[0] 10000
execute store result score @s quat_start_y run data get storage mot_uav:io input.start_xyzw[1] 10000
execute store result score @s quat_start_z run data get storage mot_uav:io input.start_xyzw[2] 10000
execute store result score @s quat_start_w run data get storage mot_uav:io input.start_xyzw[3] 10000
execute store result score @s quat_orth_x run data get storage mot_uav:io input.orth_xyzw[0] 10000
execute store result score @s quat_orth_y run data get storage mot_uav:io input.orth_xyzw[1] 10000
execute store result score @s quat_orth_z run data get storage mot_uav:io input.orth_xyzw[2] 10000
execute store result score @s quat_orth_w run data get storage mot_uav:io input.orth_xyzw[3] 10000
execute store result score @s quat_phi run data get storage mot_uav:io input.quat_phi 10000