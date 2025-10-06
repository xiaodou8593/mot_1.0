#mot_uav:fans/spin
# mot_uav:fans/main调用

# 设置阻尼参数
scoreboard players operation damp_k int = mot_uav_fk int
#scoreboard players operation damp_f int = mot_uav_ff int
scoreboard players set damp_b int 10000

# 计算当前局部坐标系j轴和y轴夹角damp_x
scoreboard players operation inp int = jvec_y int
scoreboard players operation inp int *= inp int
scoreboard players remove inp int 100000000
scoreboard players operation inp int *= -1 int
scoreboard players operation inp int > 0 int
function math:_sqrt
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get jvec_y int
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get res int
data modify entity @s Pos set from storage math:io xyz
execute positioned 0.0 0.0 0.0 facing entity @s feet run tp @s ~ ~ ~ ~ ~
execute store result score damp_x int run data get entity @s Rotation[0] -10000
scoreboard players operation damp_x int %= 3600000 int

# 阻尼冲量参数
scoreboard players operation damp_f int = damp_x int
scoreboard players operation damp_f int /= mot_uav_fm int
scoreboard players operation damp_f int > mot_uav_ff int

# 计算回正旋转轴uvec
scoreboard players set vec_y int 0
scoreboard players operation vec_x int = jvec_z int
scoreboard players operation vec_z int = jvec_x int
scoreboard players operation vec_z int *= -1 int
function math:vec/_norm

# 计算当前角速度沿旋转轴分量damp_v
scoreboard players operation damp_v int = angular_x int
scoreboard players operation damp_v int *= uvec_x int
scoreboard players operation sstemp int = angular_y int
scoreboard players operation sstemp int *= uvec_y int
scoreboard players operation damp_v int += sstemp int
scoreboard players operation sstemp int = angular_z int
scoreboard players operation sstemp int *= uvec_z int
scoreboard players operation damp_v int += sstemp int
scoreboard players operation damp_v int /= 10000 int

# 判定阻尼运动终止
function math:damp/_energy
scoreboard players operation temp_e int = res int
function math:damp/_threshold
execute if score temp_e int <= res int run return fail

# 阻尼迭代
scoreboard players operation temp_v int = damp_v int
function math:damp/_iter

# 计算角速度变化量
scoreboard players operation damp_v int -= temp_v int
scoreboard players operation uvec_x int *= damp_v int
scoreboard players operation uvec_y int *= damp_v int
scoreboard players operation uvec_z int *= damp_v int
scoreboard players operation uvec_x int /= 10000 int
scoreboard players operation uvec_y int /= 10000 int
scoreboard players operation uvec_z int /= 10000 int

# 更新角速度
scoreboard players operation angular_x int += uvec_x int
scoreboard players operation angular_y int += uvec_y int
scoreboard players operation angular_z int += uvec_z int
function mot_uav:angular/_update