#mot_uav:program/up/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

scoreboard players set state int 1

# 计算target_y
scoreboard players operation target_y int = y int
scoreboard players operation target_y int += delta_y int

# 转存为height程序
data modify storage mot_uav:io ptr set value "mot_uav:program/height"