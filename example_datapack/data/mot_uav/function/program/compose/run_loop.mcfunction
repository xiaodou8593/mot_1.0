#mot_uav:program/compose/run_loop
# mot_uav:program/compose/_run调用

$function $(pointer)/_proj
$function $(pointer)/_run
$function $(pointer)/_model

data modify storage mot_uav:io list_programs[0] set from storage mot_uav:io result
data modify storage mot_uav:io list_programs append from storage mot_uav:io list_programs[0]
data remove storage mot_uav:io list_programs[0]
data modify storage mot_uav:io input set from storage mot_uav:io list_programs[0]
scoreboard players remove ssloop int 1
execute if score ssloop int matches 1.. run function mot_uav:program/compose/run_loop with storage mot_uav:io input