#mot_uav:program/facing/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score target_y int run data get storage mot_uav:io input.target_y 10000
execute store result score vec_x int run data get storage mot_uav:io input.facing_pos[0] 10000
execute store result score vec_y int run data get storage mot_uav:io input.facing_pos[1] 10000
execute store result score vec_z int run data get storage mot_uav:io input.facing_pos[2] 10000
execute store result score damp_k int run data get storage mot_uav:io input.damp_params[0] 10000
execute store result score damp_b int run data get storage mot_uav:io input.damp_params[1] 10000
execute store result score damp_f int run data get storage mot_uav:io input.damp_params[2] 10000
execute store result score state int run data get storage mot_uav:io input.state