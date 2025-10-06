#mot_uav:test/position/main

# 打开电机
execute if score @s killtime matches 495 run function mot_uav:fans/_on

# 上传高度程序
execute if score @s killtime matches 490 run function mot_uav:test/height_program

# 上传位移程序
execute if score @s killtime matches 400 run function mot_uav:test/position_program