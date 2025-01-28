#mot_uav:test/angular/s3

# 角速度阻尼
function mot_uav:_get
scoreboard players set inp int 9900
function mot_uav:angular/_factor
function mot_uav:_store

# 渲染局部坐标系
scoreboard players set vec_n int 100
scoreboard players set vec_scale int 2
execute as @e[tag=math_marker,limit=1] run function math:uvw/_render_debug

# 渲染角速度向量
scoreboard players operation vec_x int = angular_x int
scoreboard players operation vec_y int = angular_y int
scoreboard players operation vec_z int = angular_z int
data modify storage math:io render_command set from storage math:class particle_commands.purple_dust
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get x int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players get y int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get z int
data modify entity @e[tag=math_marker,limit=1] Pos set from storage math:io xyz
execute as @e[tag=math_marker,limit=1] at @s run function math:vec/_render_debug

# 当角速度衰减足够小后跳转到状态-1
execute if score angular_len int matches ..1000 run data modify storage marker_control:io result.state set value -1