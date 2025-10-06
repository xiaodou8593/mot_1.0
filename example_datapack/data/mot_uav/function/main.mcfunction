#mot_uav:main
# mot_uav:tick调用
# 实体对象主程序

function mot_uav:_get

# 静体优化
execute unless score motion_static int matches 0 as 0-0-0-0-0 if function mot_uav:static/detect run return fail

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
execute if score vx int matches ..-1 run scoreboard players add vx int 9999
execute if score vy int matches ..-1 run scoreboard players add vy int 9999
execute if score vz int matches ..-1 run scoreboard players add vz int 9999
scoreboard players operation vx int /= 10000 int
scoreboard players operation vy int /= 10000 int
scoreboard players operation vz int /= 10000 int

# 角速度阻尼
scoreboard players operation inp int = mot_uav_ak int
function mot_uav:angular/_factor

# 重力加速度
scoreboard players operation vy int -= mot_uav_g int

# 遍历碰撞点列表
#data modify storage mot_uav:io list_impulse set value []
execute store result score loop int run data get storage mot_uav:io collision_points
execute if score loop int matches 1.. as 0-0-0-0-0 run function mot_uav:collision/loop
scoreboard players set temp_c int 0
execute if data storage mot_uav:io list_impulse[0] run function mot_uav:collision/apply

# 机翼电机
execute if score fans_power int matches 1.. run function mot_uav:fans/main

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
data modify entity @s transformation.left_rotation set from storage math:io xyzw
execute store success score sres int run data modify storage mot_uav:io cmp set from entity @s transformation.left_rotation
execute if score sres int matches 1 run data modify entity @s start_interpolation set value 0
execute on passengers if entity @s[tag=!local_quat] run function mot_uav:display/sync_pose
execute on passengers if entity @s[tag=local_quat] run function mot_uav:display/sync_local

# 外接设备
execute if score left_slot_id int matches 1.. run function mot_uav:left_slot/main
execute if score down_slot_id int matches 1.. run function mot_uav:down_slot/main
execute if score right_slot_id int matches 1.. run function mot_uav:right_slot/main

# 同步机翼电机开关
scoreboard players set temp int 1
execute if score @s fans_power matches 0 if score fans_power int matches 1.. run scoreboard players set temp int 0
execute if score @s fans_power matches 1.. if score fans_power int matches 0 run scoreboard players set temp int 0
execute if score temp int matches 0 run function mot_uav:fans/_update
function mot_uav:_store

# 同步iframe_box数据
scoreboard players operation @s x_min = @s x
scoreboard players operation @s y_min = @s y
scoreboard players operation @s z_min = @s z
scoreboard players remove @s x_min 2500
scoreboard players remove @s y_min 2500
scoreboard players remove @s z_min 2500
scoreboard players operation @s x_max = @s x
scoreboard players operation @s y_max = @s y
scoreboard players operation @s z_max = @s z
scoreboard players add @s x_max 2500
scoreboard players add @s y_max 2500
scoreboard players add @s z_max 2500

# 坐标安全
execute unless score y int matches -640000..5120000 run function mot_uav:_del