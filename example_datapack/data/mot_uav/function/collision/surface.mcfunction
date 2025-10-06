#mot_uav:collision/surface
# mot_uav:collision/apply调用

# 法向量方向检测
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get impulse_fx int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players get impulse_fy int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get impulse_fz int
data modify entity @s Pos set from storage math:io xyz
execute positioned 0.0 0.0 0.0 facing entity @s feet run tp @s ^ ^ ^1.0
execute positioned 0.0 1.0 0.0 unless entity @s[distance=..0.1] run return fail

# 四元数规整化
function math:quat/_regular

# 角度修正过大则放弃着陆
function math:rquat/_dist_sqr
execute if score res int > mot_uav_sa int run return fail

# 应用修正四元数
function math:rquat/_to_quat

# 清空速度和角速度
#scoreboard players set vx int 0
scoreboard players set vy int 0
#scoreboard players set vz int 0
scoreboard players operation vx int *= mot_uav_ek int
scoreboard players operation vz int *= mot_uav_ek int
scoreboard players operation vx int /= 10000 int
scoreboard players operation vz int /= 10000 int
scoreboard players set angular_x int 0
scoreboard players set angular_y int 0
scoreboard players set angular_z int 0
function mot_uav:angular/_update

# 同步局部坐标系
function math:quat/_touvw

scoreboard players set res int 0

# 获取底盘位置
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get x int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get z int
scoreboard players operation sstempy int = y int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players operation sstempy int -= mot_uav_ch int

# 检测是否陷进方块里面
data modify entity @s Pos set from storage math:io xyz
execute at @s if block ~ ~ ~ #mot_uav:pass run return run tp @s 0 0 0

# 修正位置
scoreboard players operation y int = sstempy int
scoreboard players operation sstempy int %= 10000 int
scoreboard players operation y int /= 10000 int
scoreboard players operation y int *= 10000 int
execute if score sstempy int matches 1.. run scoreboard players add y int 9990
scoreboard players operation y int += mot_uav_ch int

# 进入静止状态
execute if score vx int matches 0 if score vz int matches 0 run scoreboard players set motion_static int 1

# 区块安全
tp @s 0 0 0