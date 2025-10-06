#mot_uav:collision/bounce
# mot_uav:collision/loop调用

function mot_uav:collision/_get_norm

# 计算碰撞点的速度大小 (平动速度叠加旋转的线速度)
scoreboard players operation vec_x int = angular_x int
scoreboard players operation vec_y int = angular_y int
scoreboard players operation vec_z int = angular_z int
scoreboard players operation fvec_x int = @s x
scoreboard players operation fvec_y int = @s y
scoreboard players operation fvec_z int = @s z
scoreboard players operation fvec_x int -= x int
scoreboard players operation fvec_y int -= y int
scoreboard players operation fvec_z int -= z int
function math:vec/_cross_fvec
# 转换弧度制
scoreboard players operation vec_x int *= 349 int
scoreboard players operation vec_y int *= 349 int
scoreboard players operation vec_z int *= 349 int
scoreboard players operation vec_x int /= 10000 int
scoreboard players operation vec_y int /= 10000 int
scoreboard players operation vec_z int /= 10000 int
# 叠加平动速度
scoreboard players operation vec_x int += vx int
scoreboard players operation vec_y int += vy int
scoreboard players operation vec_z int += vz int

# 与法向量点乘
scoreboard players operation vec_x int *= nvec_x int
scoreboard players operation vec_y int *= nvec_y int
scoreboard players operation vec_z int *= nvec_z int
scoreboard players operation vec_x int += vec_y int
scoreboard players operation vec_x int += vec_z int
scoreboard players operation vec_x int /= 10000 int

# 如果速度方向是正在离开介质的，那么就不施加冲量
execute if score vec_x int matches 1.. run return fail

# 设置冲量的作用点
scoreboard players operation impulse_x int = @s x
scoreboard players operation impulse_y int = @s y
scoreboard players operation impulse_z int = @s z

# 根据弹性系数计算冲量大小
scoreboard players operation sstemp_v int = vec_x int
scoreboard players operation vec_x int *= mot_uav_b int
scoreboard players operation vec_x int /= -10000 int
scoreboard players operation vec_x int -= sstemp_v int
scoreboard players operation vec_x int *= mot_uav_m int

# 设置冲量的矢量部分
scoreboard players operation impulse_fx int = nvec_x int
scoreboard players operation impulse_fy int = nvec_y int
scoreboard players operation impulse_fz int = nvec_z int
scoreboard players operation impulse_fx int *= vec_x int
scoreboard players operation impulse_fy int *= vec_x int
scoreboard players operation impulse_fz int *= vec_x int
scoreboard players operation impulse_fx int /= 10000 int
scoreboard players operation impulse_fy int /= 10000 int
scoreboard players operation impulse_fz int /= 10000 int

# 对mot_uav临时对象施加矢量
#function mot_uav:impulse/_apply
function mot_uav:impulse/_model
data modify storage mot_uav:io list_impulse append from storage mot_uav:io result