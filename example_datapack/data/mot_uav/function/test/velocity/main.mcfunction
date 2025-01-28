#mot_uav:test/velocity/main

# 实体对象数据临时化
function mot_uav:_get
scoreboard players set vx int 1000
scoreboard players set vy int 1000
scoreboard players set vz int 1000
function mot_uav:_store

# 渲染局部坐标系
scoreboard players set vec_n int 200
scoreboard players set vec_scale int 2
execute as @e[tag=math_marker,limit=1] run function math:uvw/_render_debug