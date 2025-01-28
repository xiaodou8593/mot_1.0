#mot_uav:test/angular/main

function marker_control:data/_get

# 选择执行的状态
execute store result score temp_state int run data get storage marker_control:io result.state
execute if score temp_state int matches 0 run function mot_uav:test/angular/s0
execute if score temp_state int matches 1 run function mot_uav:test/angular/s1
execute if score temp_state int matches 2 run function mot_uav:test/angular/s2
execute if score temp_state int matches 3 run function mot_uav:test/angular/s3

# -1状态表示结束测试
execute unless score temp_state int matches -1 run scoreboard players set @s killtime 20

function marker_control:data/_store