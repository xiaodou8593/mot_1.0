#mot_uav:test/coord_sys/main

# 实体对象数据临时化
function mot_uav:_get

# 渲染局部坐标系
scoreboard players set vec_n int 200
scoreboard players set vec_scale int 2
execute as @e[tag=math_marker,limit=1] run function math:uvw/_render_debug