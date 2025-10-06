#mot_uav:program/landing/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 计算target_y
scoreboard players operation vec_x int = x int
scoreboard players operation vec_y int = y int
scoreboard players operation vec_z int = z int
scoreboard players operation vec_y int -= mot_uav_ch int
scoreboard players operation vec_x int /= 10000 int
scoreboard players operation vec_y int /= 10000 int
scoreboard players operation vec_z int /= 10000 int
scoreboard players remove vec_y int 1
scoreboard players operation vec_x int *= 10000 int
scoreboard players operation vec_y int *= 10000 int
scoreboard players operation vec_z int *= 10000 int
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players add vec_x int 5000
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players add vec_y int 5000
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players add vec_z int 5000
data modify entity @s Pos set from storage math:io xyz
scoreboard players operation target_y int = vec_y int
execute at @s unless block ~ ~ ~ #mot_uav:pass run scoreboard players add target_y int 5100
scoreboard players operation target_y int += mot_uav_ch int

function mot_uav:program/landing/_model
data modify storage mot_uav:io temp set from storage mot_uav:io result

# 维持高度
data modify storage mot_uav:io input set from storage mot_uav:class default_programs[{id:"height"}]
execute store result storage mot_uav:io input.target_y double 0.0001 run scoreboard players get target_y int
function mot_uav:program/height/_proj
function mot_uav:program/height/_run
# 状态变量设置为height程序的状态
execute store result storage mot_uav:io temp.state int 1 run scoreboard players get state int

data modify storage mot_uav:io input set from storage mot_uav:io temp
function mot_uav:program/landing/_proj

# 区块安全
tp @s 0 0 0