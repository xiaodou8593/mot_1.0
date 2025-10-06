#mot_uav:program/rotation/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 获取当前偏航角
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get kvec_x int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get kvec_z int
data modify entity @s Pos set from storage math:io xyz
execute positioned 0.0 0.0 0.0 facing entity @s feet run tp @s ~ ~ ~ ~ ~
execute store result score damp_x int run data get entity @s Rotation[0] -10000

# 选取劣弧作为转动路径
scoreboard players operation damp_x int -= target_theta int
scoreboard players operation damp_x int %= 3600000 int
execute if score damp_x int matches 1800000.. run scoreboard players remove damp_x int 3600000

# 获取当前偏航角速度
scoreboard players operation damp_v int = angular_y int

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
scoreboard players operation angular_y int = damp_v int
function mot_uav:angular/_update

function mot_uav:program/rotation/_model
data modify storage mot_uav:io temp set from storage mot_uav:io result

# 维持高度
data modify storage mot_uav:io input set from storage mot_uav:class default_programs[{id:"height"}]
execute store result storage mot_uav:io input.target_y double 0.0001 run scoreboard players get target_y int
function mot_uav:program/height/_proj
function mot_uav:program/height/_run

data modify storage mot_uav:io input set from storage mot_uav:io temp
function mot_uav:program/rotation/_proj