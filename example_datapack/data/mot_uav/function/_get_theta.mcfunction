#mot_uav:_get_theta
# 获取无人机当前偏航角
# 输出<theta,int,1w>
# 需要传入世界实体

execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get kvec_x int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get kvec_z int
data modify entity @s Pos set from storage math:io xyz
execute positioned 0.0 0.0 0.0 facing entity @s feet run tp @s ~ ~ ~ ~ ~
execute store result score theta int run data get entity @s Rotation[0] -10000
scoreboard players operation theta int %= 3600000 int
execute if score theta int matches 1800000.. run scoreboard players remove theta int 3600000