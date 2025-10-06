#mot_uav:impulse/_proj
# 冲量的数据模板投射到临时对象
# 输入数据模板storage mot_uav:io input

execute store result score impulse_fx int run data get storage mot_uav:io input.vector[0] 10000
execute store result score impulse_fy int run data get storage mot_uav:io input.vector[1] 10000
execute store result score impulse_fz int run data get storage mot_uav:io input.vector[2] 10000
execute store result score impulse_x int run data get storage mot_uav:io input.point[0] 10000
execute store result score impulse_y int run data get storage mot_uav:io input.point[1] 10000
execute store result score impulse_z int run data get storage mot_uav:io input.point[2] 10000