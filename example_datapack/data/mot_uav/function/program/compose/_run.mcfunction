#mot_uav:program/compose/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

data modify storage mot_uav:io input set from storage mot_uav:io list_programs[0]
execute store result score ssloop int run data get storage mot_uav:io list_programs
execute if score ssloop int matches 1.. run function mot_uav:program/compose/run_loop with storage mot_uav:io input

scoreboard players set state int 2
execute if data storage mot_uav:io list_programs[{state:0}] run scoreboard players set state int 0
execute if data storage mot_uav:io list_programs[{state:1}] run scoreboard players set state int 1
execute if data storage mot_uav:io list_programs[{state:-1}] run scoreboard players set state int -1
data modify storage mot_uav:io ptr set value "mot_uav:program/compose"