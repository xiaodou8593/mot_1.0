#mot_uav:program/forward/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

execute store result score u int run data get storage mot_uav:io input.u 10000
execute store result score v int run data get storage mot_uav:io input.v 10000
execute store result score w int run data get storage mot_uav:io input.w 10000
data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score target_y int run data get storage mot_uav:io input.target_y 10000
execute store result score target_x int run data get storage mot_uav:io input.target_pos[0] 10000
execute store result score target_z int run data get storage mot_uav:io input.target_pos[2] 10000
execute store result score damp_k int run data get storage mot_uav:io input.damp_params[0] 10000
execute store result score damp_b int run data get storage mot_uav:io input.damp_params[1] 10000
execute store result score damp_f int run data get storage mot_uav:io input.damp_params[2] 10000
execute store result score state int run data get storage mot_uav:io input.state