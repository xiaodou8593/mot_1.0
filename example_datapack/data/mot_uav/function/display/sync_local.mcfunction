#mot_uav:display/sync_local
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

# 将本地四元数姿态iquat右乘给整体四元数姿态quat，输出为rquat
function math:iquat/_get
function math:quat/_pre_mult
execute store result storage math:io xyzw[0] float 0.0001 run scoreboard players get rquat_x int
execute store result storage math:io xyzw[1] float 0.0001 run scoreboard players get rquat_y int
execute store result storage math:io xyzw[2] float 0.0001 run scoreboard players get rquat_z int
execute store result storage math:io xyzw[3] float 0.0001 run scoreboard players get rquat_w int

# 成功修改姿态才会播放插值动画
data modify storage mot_uav:io cmp set from entity @s transformation.left_rotation
data modify entity @s transformation.left_rotation set from storage math:io xyzw
execute store success score sres int run data modify storage mot_uav:io cmp set from entity @s transformation.left_rotation
execute if score sres int matches 1 run data modify entity @s start_interpolation set value 0