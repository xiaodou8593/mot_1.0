#mot_uav:impulse/_apply
# 把冲量施加给mot_uav的临时对象

# 改变速度
scoreboard players operation vec_x int = impulse_fx int
scoreboard players operation vec_y int = impulse_fy int
scoreboard players operation vec_z int = impulse_fz int
scoreboard players operation vec_x int /= mot_uav_m int
scoreboard players operation vec_y int /= mot_uav_m int
scoreboard players operation vec_z int /= mot_uav_m int
scoreboard players operation vx int += vec_x int
scoreboard players operation vy int += vec_y int
scoreboard players operation vz int += vec_z int

# 计算相对于旋转中心的位矢
scoreboard players operation fvec_x int = impulse_x int
scoreboard players operation fvec_y int = impulse_y int
scoreboard players operation fvec_z int = impulse_z int
scoreboard players operation fvec_x int -= x int
scoreboard players operation fvec_y int -= y int
scoreboard players operation fvec_z int -= z int

# 叉乘计算冲量矩
scoreboard players operation vec_x int = impulse_fx int
scoreboard players operation vec_y int = impulse_fy int
scoreboard players operation vec_z int = impulse_fz int
function math:vec/_cross_fvec

# 改变角速度 (假设转动惯量在各方向均匀)
scoreboard players operation angular_x int -= vec_x int
scoreboard players operation angular_y int -= vec_y int
scoreboard players operation angular_z int -= vec_z int

function mot_uav:angular/_update