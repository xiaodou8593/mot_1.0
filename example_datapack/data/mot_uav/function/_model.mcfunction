#mot_uav:_model
# 使用临时对象构建数据模板
# 输出数据模板storage mot_uav:io result

data modify storage mot_uav:io result set value {velocity:[0.0d, 0.0d, 0.0d], angular_vec:[0.0d, 0.0d, 0.0d], angular_len:0, position:[0.0d, 0.0d, 0.0d], ivec:[0.0d, 0.0d, 0.0d], jvec:[0.0d, 0.0d, 0.0d], kvec:[0.0d, 0.0d, 0.0d], xyzw:[0.0d, 0.0d, 0.0d, 0.0d], start_xyzw:[0.0d, 0.0d, 0.0d, 0.0d], orth_xyzw:[0.0d, 0.0d, 0.0d, 0.0d], quat_phi:0}

execute store result storage mot_uav:io result.velocity[0] double 0.0001 run scoreboard players get vx int
execute store result storage mot_uav:io result.velocity[1] double 0.0001 run scoreboard players get vy int
execute store result storage mot_uav:io result.velocity[2] double 0.0001 run scoreboard players get vz int
execute store result storage mot_uav:io result.angular_vec[0] double 0.0001 run scoreboard players get angular_x int
execute store result storage mot_uav:io result.angular_vec[1] double 0.0001 run scoreboard players get angular_y int
execute store result storage mot_uav:io result.angular_vec[2] double 0.0001 run scoreboard players get angular_z int
execute store result storage mot_uav:io result.angular_len int 0.0001 run scoreboard players get angular_len int
execute store result storage mot_uav:io result.position[0] double 0.0001 run scoreboard players get x int
execute store result storage mot_uav:io result.position[1] double 0.0001 run scoreboard players get y int
execute store result storage mot_uav:io result.position[2] double 0.0001 run scoreboard players get z int
execute store result storage mot_uav:io result.ivec[0] double 0.0001 run scoreboard players get ivec_x int
execute store result storage mot_uav:io result.ivec[1] double 0.0001 run scoreboard players get ivec_y int
execute store result storage mot_uav:io result.ivec[2] double 0.0001 run scoreboard players get ivec_z int
execute store result storage mot_uav:io result.jvec[0] double 0.0001 run scoreboard players get jvec_x int
execute store result storage mot_uav:io result.jvec[1] double 0.0001 run scoreboard players get jvec_y int
execute store result storage mot_uav:io result.jvec[2] double 0.0001 run scoreboard players get jvec_z int
execute store result storage mot_uav:io result.kvec[0] double 0.0001 run scoreboard players get kvec_x int
execute store result storage mot_uav:io result.kvec[1] double 0.0001 run scoreboard players get kvec_y int
execute store result storage mot_uav:io result.kvec[2] double 0.0001 run scoreboard players get kvec_z int
execute store result storage mot_uav:io result.xyzw[0] double 0.0001 run scoreboard players get quat_x int
execute store result storage mot_uav:io result.xyzw[1] double 0.0001 run scoreboard players get quat_y int
execute store result storage mot_uav:io result.xyzw[2] double 0.0001 run scoreboard players get quat_z int
execute store result storage mot_uav:io result.xyzw[3] double 0.0001 run scoreboard players get quat_w int
execute store result storage mot_uav:io result.start_xyzw[0] double 0.0001 run scoreboard players get quat_start_x int
execute store result storage mot_uav:io result.start_xyzw[1] double 0.0001 run scoreboard players get quat_start_y int
execute store result storage mot_uav:io result.start_xyzw[2] double 0.0001 run scoreboard players get quat_start_z int
execute store result storage mot_uav:io result.start_xyzw[3] double 0.0001 run scoreboard players get quat_start_w int
execute store result storage mot_uav:io result.orth_xyzw[0] double 0.0001 run scoreboard players get quat_orth_x int
execute store result storage mot_uav:io result.orth_xyzw[1] double 0.0001 run scoreboard players get quat_orth_y int
execute store result storage mot_uav:io result.orth_xyzw[2] double 0.0001 run scoreboard players get quat_orth_z int
execute store result storage mot_uav:io result.orth_xyzw[3] double 0.0001 run scoreboard players get quat_orth_w int
execute store result storage mot_uav:io result.quat_phi int 0.0001 run scoreboard players get quat_phi int