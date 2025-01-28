#mot_uav:main
# mot_uav:tick调用
# 实体对象主程序

function mot_uav:_get

# 速度迭代
scoreboard players operation x int += vx int
scoreboard players operation y int += vy int
scoreboard players operation z int += vz int

# 角速度的四元数迭代
scoreboard players operation quat_phi int += angular_len int
execute as 0-0-0-0-0 run function math:quat/_xyzw
# 四元数姿态同步到局部坐标系
function math:quat/_touvw

# 速度阻尼
scoreboard players operation vx int *= mot_uav_k int
scoreboard players operation vy int *= mot_uav_k int
scoreboard players operation vz int *= mot_uav_k int
scoreboard players operation vx int /= 10000 int
scoreboard players operation vy int /= 10000 int
scoreboard players operation vz int /= 10000 int

# 重力加速度
scoreboard players operation vy int -= mot_uav_g int

# 遍历碰撞点列表
execute store result score loop int run data get storage mot_uav:io collision_points
execute if score loop int matches 1.. as 0-0-0-0-0 run function mot_uav:collision/loop

# 同步实体坐标
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get x int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players get y int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get z int
data modify entity @s Pos set from storage math:io xyz

# 同步四元数姿态
execute store result storage math:io xyzw[0] float 0.0001 run scoreboard players get quat_x int
execute store result storage math:io xyzw[1] float 0.0001 run scoreboard players get quat_y int
execute store result storage math:io xyzw[2] float 0.0001 run scoreboard players get quat_z int
execute store result storage math:io xyzw[3] float 0.0001 run scoreboard players get quat_w int
# 成功修改姿态才会播放插值动画
data modify storage mot_uav:io cmp set from entity @s transformation.left_rotation
execute store success score sres int run data modify storage mot_uav:io cmp set from storage math:io xyzw
execute if score sres int matches 1 run data modify entity @s start_interpolation set value 0
data modify entity @s transformation.left_rotation set from storage math:io xyzw
execute on passengers run function mot_uav:display/sync_pose

function mot_uav:_store

# 坐标安全
execute unless score y int matches -640000..5120000 run function mot_uav:_del