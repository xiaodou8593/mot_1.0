#mot_uav:test/facing/enemy_not_found
# mot_uav:test/facing/get_enemy调用

execute store result score target_y int run data get storage mot_uav:io program.target_y 10000
data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"waiting"}]
execute store result storage mot_uav:io program.target_y double 0.0001 run scoreboard players get target_y int