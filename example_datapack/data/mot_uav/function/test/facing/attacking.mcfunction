#mot_uav:test/facing/attacking
# mot_uav:test/facing/main调用

# 测试粒子

execute store result score temp_cnt int run data get storage marker_control:io result.attack_cnt
execute store result storage marker_control:io result.attack_cnt int 1 run scoreboard players remove temp_cnt int 1
execute if score temp_cnt int matches ..0 run return run function mot_uav:test/facing/s_get_enemy

data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"compose"}]
data modify storage mot_uav:io program.list_programs append from storage marker_control:io result.facing_program
data modify storage mot_uav:io program.list_programs append from storage mot_uav:class default_programs[{id:"left_use"}]