#mot_uav:test/program/main

# 打开电机
execute if score @s killtime matches 495 run function mot_uav:fans/_on

# 处理控制程序管线
execute if score @s killtime matches 491.. run return fail
function marker_control:data/_get

# 管线清空后结束测试
execute unless data storage marker_control:io result.lst_programs[0] run return fail
scoreboard players set @s killtime 10

# 检测当前程序运行状态
function mot_uav:_get_program
execute unless data storage mot_uav:io program{state:1} run function mot_uav:test/program/upload_program