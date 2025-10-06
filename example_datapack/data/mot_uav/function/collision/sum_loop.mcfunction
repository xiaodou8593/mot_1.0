#mot_uav:collision/sum_loop
# mot_uav:collision/apply调用

# 把冲量的数据模板投射到临时对象
data modify storage mot_uav:io input set from storage mot_uav:io list_impulse[0]
function mot_uav:impulse/_proj
scoreboard players operation vec_x int += impulse_fx int
scoreboard players operation vec_y int += impulse_fy int
scoreboard players operation vec_z int += impulse_fz int

# 扫描每个冲量
data modify storage mot_uav:io list_impulse append from storage mot_uav:io list_impulse[0]
data remove storage mot_uav:io list_impulse[0]
scoreboard players remove loop int 1
execute if score loop int matches 1.. run function mot_uav:collision/sum_loop