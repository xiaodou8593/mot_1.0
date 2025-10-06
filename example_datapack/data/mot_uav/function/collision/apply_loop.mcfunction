#mot_uav:collision/apply_loop
# mot_uav:collision/apply调用

# 把冲量投射为临时对象
data modify storage mot_uav:io input set from storage mot_uav:io list_impulse[0]
function mot_uav:impulse/_proj

# 根据权重调整冲量大小
scoreboard players operation impulse_fx int /= cnt_impulse int
scoreboard players operation impulse_fy int /= cnt_impulse int
scoreboard players operation impulse_fz int /= cnt_impulse int

# 施加冲量
function mot_uav:impulse/_apply

# 遍历每个冲量
data remove storage mot_uav:io list_impulse[0]
execute if data storage mot_uav:io list_impulse[0] run function mot_uav:collision/apply_loop