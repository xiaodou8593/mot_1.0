#mot_uav:program/waiting/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

scoreboard players set state int 1
execute if score wait_time int matches 1.. run scoreboard players remove wait_time int 1
execute if score wait_time int matches 0 run scoreboard players set state int 2

function mot_uav:program/waiting/_model
data modify storage mot_uav:io temp set from storage mot_uav:io result

# 维持高度
data modify storage mot_uav:io input set from storage mot_uav:class default_programs[{id:"height"}]
execute store result storage mot_uav:io input.target_y double 0.0001 run scoreboard players get target_y int
function mot_uav:program/height/_proj
function mot_uav:program/height/_run

data modify storage mot_uav:io input set from storage mot_uav:io temp
function mot_uav:program/waiting/_proj