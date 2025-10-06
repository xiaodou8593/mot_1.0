#mot_mover:set
# mot_mover:_new调用

data modify entity @s item.components."minecraft:custom_data".block_id set from storage mot_mover:io input.block_id
data modify entity @s item.components."minecraft:custom_data".block_state set from storage mot_mover:io input.block_state
data modify entity @s item.components."minecraft:custom_data".block_nbt set from storage mot_mover:io input.block_nbt
data modify entity @s item.components."minecraft:custom_data".slot_type set from storage mot_mover:io input.slot_type
execute store result score @s mot_uav_root run data get storage mot_mover:io input.mot_uav_root
execute store result score @s motion_static run data get storage mot_mover:io input.motion_static
data modify entity @s item.components."minecraft:custom_data".list_impulse set from storage mot_mover:io input.list_impulse
execute store result score @s vx run data get storage mot_mover:io input.velocity[0] 10000
execute store result score @s vy run data get storage mot_mover:io input.velocity[1] 10000
execute store result score @s vz run data get storage mot_mover:io input.velocity[2] 10000
execute store result score @s angular_x run data get storage mot_mover:io input.angular_vec[0] 10000
execute store result score @s angular_y run data get storage mot_mover:io input.angular_vec[1] 10000
execute store result score @s angular_z run data get storage mot_mover:io input.angular_vec[2] 10000
execute store result score @s angular_len run data get storage mot_mover:io input.angular_len 10000
execute store result score @s x run data get storage mot_mover:io input.position[0] 10000
execute store result score @s y run data get storage mot_mover:io input.position[1] 10000
execute store result score @s z run data get storage mot_mover:io input.position[2] 10000
execute store result score @s ivec_x run data get storage mot_mover:io input.ivec[0] 10000
execute store result score @s ivec_y run data get storage mot_mover:io input.ivec[1] 10000
execute store result score @s ivec_z run data get storage mot_mover:io input.ivec[2] 10000
execute store result score @s jvec_x run data get storage mot_mover:io input.jvec[0] 10000
execute store result score @s jvec_y run data get storage mot_mover:io input.jvec[1] 10000
execute store result score @s jvec_z run data get storage mot_mover:io input.jvec[2] 10000
execute store result score @s kvec_x run data get storage mot_mover:io input.kvec[0] 10000
execute store result score @s kvec_y run data get storage mot_mover:io input.kvec[1] 10000
execute store result score @s kvec_z run data get storage mot_mover:io input.kvec[2] 10000
execute store result score @s quat_x run data get storage mot_mover:io input.xyzw[0] 10000
execute store result score @s quat_y run data get storage mot_mover:io input.xyzw[1] 10000
execute store result score @s quat_z run data get storage mot_mover:io input.xyzw[2] 10000
execute store result score @s quat_w run data get storage mot_mover:io input.xyzw[3] 10000
execute store result score @s quat_start_x run data get storage mot_mover:io input.start_xyzw[0] 10000
execute store result score @s quat_start_y run data get storage mot_mover:io input.start_xyzw[1] 10000
execute store result score @s quat_start_z run data get storage mot_mover:io input.start_xyzw[2] 10000
execute store result score @s quat_start_w run data get storage mot_mover:io input.start_xyzw[3] 10000
execute store result score @s quat_orth_x run data get storage mot_mover:io input.orth_xyzw[0] 10000
execute store result score @s quat_orth_y run data get storage mot_mover:io input.orth_xyzw[1] 10000
execute store result score @s quat_orth_z run data get storage mot_mover:io input.orth_xyzw[2] 10000
execute store result score @s quat_orth_w run data get storage mot_mover:io input.orth_xyzw[3] 10000
execute store result score @s quat_phi run data get storage mot_mover:io input.quat_phi 10000