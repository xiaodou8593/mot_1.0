#mot_uav:program/turn/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

scoreboard players set state int 1

# 计算target_theta
function mot_uav:_get_theta
scoreboard players operation target_theta int = theta int
scoreboard players operation target_theta int += delta_theta int

# 转存为rotation程序
data modify storage mot_uav:io ptr set value "mot_uav:program/rotation"