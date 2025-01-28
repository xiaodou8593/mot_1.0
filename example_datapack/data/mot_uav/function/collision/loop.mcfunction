#mot_uav:collision/loop
# mot_uav:main调用

# 调用局部坐标系的临时对象，访问碰撞点
execute store result score u int run data get storage mot_uav:io collision_points[0][0] 10000
execute store result score v int run data get storage mot_uav:io collision_points[0][1] 10000
execute store result score w int run data get storage mot_uav:io collision_points[0][2] 10000
function math:uvw/_topos
execute at @s unless block ~ ~ ~ #mot_uav:pass run function mot_uav:collision/bounce

# 扫描每个碰撞点
data modify storage mot_uav:io collision_points append from storage mot_uav:io collision_points[0]
data remove storage mot_uav:io collision_points[0]
scoreboard players remove loop int 1
execute if score loop int matches 1.. run function mot_uav:collision/loop