#mot_uav:program/position/apply_impulse
# mot_uav:program/position/_run调用

# 计算冲量大小
scoreboard players operation impulse_fx int = damp_vx int
scoreboard players operation impulse_fz int = damp_vz int
scoreboard players operation impulse_fx int -= vx int
scoreboard players operation impulse_fz int -= vz int
scoreboard players operation impulse_fx int *= mot_uav_m int
scoreboard players operation impulse_fz int *= mot_uav_m int
scoreboard players set impulse_fy int 0

# 计算冲量作用点
execute store result storage math:io xyz[0] double -0.0001 run scoreboard players get impulse_fx int
execute store result storage math:io xyz[2] double -0.0001 run scoreboard players get impulse_fz int
data modify storage math:io xyz[1] set value 0.0d
data modify entity @s Pos set from storage math:io xyz
execute positioned 0.0 0.0 0.0 facing entity @s feet run tp @s ^ ^ ^1.0
data modify storage math:io xyz set from entity @s Pos
execute store result score impulse_x int run data get storage math:io xyz[0] 10000
execute store result score impulse_z int run data get storage math:io xyz[2] 10000
scoreboard players operation impulse_x int += x int
scoreboard players operation impulse_z int += z int
scoreboard players operation impulse_y int = y int
scoreboard players add impulse_y int 12500

# 施加冲量
function mot_uav:impulse/_apply