#mot_uav:program/facing/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

scoreboard players operation sstemp_vx int = vec_x int
scoreboard players operation sstemp_vy int = vec_y int
scoreboard players operation sstemp_vz int = vec_z int
scoreboard players operation vec_x int -= x int
scoreboard players operation vec_y int -= y int
scoreboard players operation vec_z int -= z int
function math:vec/_unit_xz
scoreboard players operation uvec_y int > -3333 int
scoreboard players operation uvec_y int < 3333 int
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get uvec_x int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players get uvec_y int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get uvec_z int
data modify entity @s Pos set from storage math:io xyz
execute positioned 0.0 0.0 0.0 facing entity @s feet run function math:iquat/_facing_to

# 计算转轴和角度差
scoreboard players operation quat_x int *= -1 int
scoreboard players operation quat_y int *= -1 int
scoreboard players operation quat_z int *= -1 int
function math:quat/_mult
scoreboard players operation quat_x int *= -1 int
scoreboard players operation quat_y int *= -1 int
scoreboard players operation quat_z int *= -1 int
execute if score rquat_w int matches ..-1 run function math:rquat/_neg
function math:rquat/_touvec
scoreboard players operation res int *= -2 int
scoreboard players add res int 10000
scoreboard players operation cos int = res int
function math:_arccos
scoreboard players operation damp_x int = theta int
scoreboard players operation damp_x int *= -1 int

# 计算当前角速度沿转轴分量
scoreboard players operation damp_v int = angular_x int
scoreboard players operation damp_v int *= uvec_x int
scoreboard players operation temp int = angular_y int
scoreboard players operation temp int *= uvec_y int
scoreboard players operation damp_v int += temp int
scoreboard players operation temp int = angular_z int
scoreboard players operation temp int *= uvec_z int
scoreboard players operation damp_v int += temp int
scoreboard players operation damp_v int /= 10000 int

# 阻尼迭代
function math:damp/_iter

scoreboard players set state int 1
# 判定阻尼运动终止
function math:damp/_energy
scoreboard players operation temp_e int = res int
function math:damp/_threshold
scoreboard players operation res int *= 10 int
execute if score temp_e int <= res int run scoreboard players set state int 2
execute if score temp_e int <= res int run scoreboard players set damp_v int 0

# 更新角速度
scoreboard players operation angular_x int = uvec_x int
scoreboard players operation angular_y int = uvec_y int
scoreboard players operation angular_z int = uvec_z int
scoreboard players operation angular_x int *= damp_v int
scoreboard players operation angular_y int *= damp_v int
scoreboard players operation angular_z int *= damp_v int
scoreboard players operation angular_x int /= 10000 int
scoreboard players operation angular_y int /= 10000 int
scoreboard players operation angular_z int /= 10000 int
function mot_uav:angular/_update

scoreboard players operation vec_x int = sstemp_vx int
scoreboard players operation vec_y int = sstemp_vy int
scoreboard players operation vec_z int = sstemp_vz int
function mot_uav:program/facing/_model
data modify storage mot_uav:io temp set from storage mot_uav:io result

# 维持高度
data modify storage mot_uav:io input set from storage mot_uav:class default_programs[{id:"height"}]
execute store result storage mot_uav:io input.target_y double 0.0001 run scoreboard players get target_y int
function mot_uav:program/height/_proj
function mot_uav:program/height/_run

data modify storage mot_uav:io input set from storage mot_uav:io temp
function mot_uav:program/facing/_proj