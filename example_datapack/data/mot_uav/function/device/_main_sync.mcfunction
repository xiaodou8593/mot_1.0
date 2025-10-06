#mot_uav:device/_main_sync

function math:vec/_get

# 连接确认
scoreboard players set res int 0
execute as @e[tag=mot_device] if score @s mot_uav_id = mot_uav_root int run function module_control:_call_method {path:"_get_slot_id"}
execute unless score res int = @s mot_uav_id run return run scoreboard players set mot_uav_root int 0

# 缓存原点坐标
scoreboard players operation tempx int = x int
scoreboard players operation tempy int = y int
scoreboard players operation tempz int = z int

# 计算xyz坐标使得插槽坐标重合
scoreboard players operation u int = mot_sync_u int
scoreboard players operation v int = mot_sync_v int
scoreboard players operation w int = mot_sync_w int
function math:uvw/_tofvec
scoreboard players operation x int = vec_x int
scoreboard players operation y int = vec_y int
scoreboard players operation z int = vec_z int
scoreboard players operation x int -= fvec_x int
scoreboard players operation y int -= fvec_y int
scoreboard players operation z int -= fvec_z int

# 计算线速度
scoreboard players operation vec_x int = angular_x int
scoreboard players operation vec_y int = angular_y int
scoreboard players operation vec_z int = angular_z int
scoreboard players operation fvec_x int = x int
scoreboard players operation fvec_y int = y int
scoreboard players operation fvec_z int = z int
scoreboard players operation fvec_x int -= tempx int
scoreboard players operation fvec_y int -= tempy int
scoreboard players operation fvec_z int -= tempz int
function math:vec/_cross_fvec
# 转换弧度制
scoreboard players operation vec_x int *= 349 int
scoreboard players operation vec_y int *= 349 int
scoreboard players operation vec_z int *= 349 int
scoreboard players operation vec_x int /= 10000 int
scoreboard players operation vec_y int /= 10000 int
scoreboard players operation vec_z int /= 10000 int
# 叠加平动速度
scoreboard players operation vx int += vec_x int
scoreboard players operation vy int += vec_y int
scoreboard players operation vz int += vec_z int

# 碰撞检测
execute store result score loop int run data get storage mot_uav:io collision_points
execute if score loop int matches 1.. as 0-0-0-0-0 run function mot_uav:collision/loop

# 发送冲量
execute if data storage mot_uav:io list_impulse[0] as @e[tag=mot_device] if score @s mot_uav_id = mot_uav_root int run function mot_uav:device/connect_receive

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

# 关闭静体优化
scoreboard players set motion_static int 0