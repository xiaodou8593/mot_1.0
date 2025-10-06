#mot_scatter:update_barrel_phi
# mot_scatter:update_barrel调用

# 计算本地四元数
scoreboard players operation psi int = temp_phi int
scoreboard players operation psi int += @s scatter_phi
execute as 0-0-0-0-0 run function math:iquat/_psi_to

# 计算局部坐标
scoreboard players operation @s u = iquat_w int
scoreboard players operation @s v = iquat_z int
scoreboard players operation @s u *= 9 int
scoreboard players operation @s v *= 9 int
scoreboard players operation @s u /= 40 int
scoreboard players operation @s v /= 40 int

# 右乘俯仰旋转
scoreboard players operation iquat_w int *= 70716 int
scoreboard players operation iquat_z int *= 70716 int
scoreboard players operation iquat_w int /= 100000 int
scoreboard players operation iquat_z int /= 100000 int
scoreboard players operation iquat_y int = iquat_z int
scoreboard players operation iquat_x int = iquat_w int

function math:iquat/_store