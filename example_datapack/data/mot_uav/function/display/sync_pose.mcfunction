#mot_uav:display/sync_pose
# mot_uav:main调用

# 同步局部坐标
scoreboard players operation u int = @s u
scoreboard players operation v int = @s v
scoreboard players operation w int = @s w
function math:uvw/_tofvec
execute store result storage mot_uav:io translation[0] float 0.0001 run scoreboard players get fvec_x int
execute store result storage mot_uav:io translation[1] float 0.0001 run scoreboard players get fvec_y int
execute store result storage mot_uav:io translation[2] float 0.0001 run scoreboard players get fvec_z int
data modify entity @s transformation.translation set from storage mot_uav:io translation

# 同步四元数姿态
data modify entity @s transformation.left_rotation set from storage math:io xyzw
execute if score sres int matches 1 run data modify entity @s start_interpolation set value 0