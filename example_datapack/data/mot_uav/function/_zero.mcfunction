#mot_uav:_zero
# 把临时对象的全部数据置0

scoreboard players set left_slot_id int 0
scoreboard players set down_slot_id int 0
scoreboard players set right_slot_id int 0
data modify storage mot_uav:io program set value {}
data modify storage mot_uav:io list_impulse set value []
scoreboard players set fans_power int 0
scoreboard players set fans_theta int 0
scoreboard players set fans_timer int 0
scoreboard players set motion_static int 0
scoreboard players set vx int 0
scoreboard players set vy int 0
scoreboard players set vz int 0
scoreboard players set angular_x int 0
scoreboard players set angular_y int 0
scoreboard players set angular_z int 0
scoreboard players set angular_len int 0
scoreboard players set x int 0
scoreboard players set y int 0
scoreboard players set z int 0
scoreboard players set ivec_x int 0
scoreboard players set ivec_y int 0
scoreboard players set ivec_z int 0
scoreboard players set jvec_x int 0
scoreboard players set jvec_y int 0
scoreboard players set jvec_z int 0
scoreboard players set kvec_x int 0
scoreboard players set kvec_y int 0
scoreboard players set kvec_z int 0
scoreboard players set quat_x int 0
scoreboard players set quat_y int 0
scoreboard players set quat_z int 0
scoreboard players set quat_w int 0
scoreboard players set quat_start_x int 0
scoreboard players set quat_start_y int 0
scoreboard players set quat_start_z int 0
scoreboard players set quat_start_w int 0
scoreboard players set quat_orth_x int 0
scoreboard players set quat_orth_y int 0
scoreboard players set quat_orth_z int 0
scoreboard players set quat_orth_w int 0
scoreboard players set quat_phi int 0