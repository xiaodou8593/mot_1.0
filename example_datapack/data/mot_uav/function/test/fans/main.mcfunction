#mot_uav:test/fans/main

# 维持电机功率
#function mot_uav:_get
#scoreboard players operation fans_power int = mot_uav_g int
#function mot_uav:_store

# 过滤执行时刻
execute unless score @s killtime matches 290 run return fail

# 获取局部坐标系左上方作为冲量的作用点
scoreboard players set u int 2500
scoreboard players set v int 10000
scoreboard players set w int 0
function math:uvw/_tovec
scoreboard players operation impulse_x int = vec_x int
scoreboard players operation impulse_y int = vec_y int
scoreboard players operation impulse_z int = vec_z int

# 获取冲量的大小和方向
scoreboard players set u int -12500
scoreboard players set v int 10000
scoreboard players set w int 0
function math:uvw/_tovec
scoreboard players operation impulse_fx int = vec_x int
scoreboard players operation impulse_fy int = vec_y int
scoreboard players operation impulse_fz int = vec_z int
scoreboard players operation impulse_fx int -= impulse_x int
scoreboard players operation impulse_fy int -= impulse_y int
scoreboard players operation impulse_fz int -= impulse_z int

# 渲染冲量
execute as @e[tag=math_marker,limit=1] run function mot_uav:impulse/_render

# 施加冲量
function mot_uav:impulse/_apply

function mot_uav:_store