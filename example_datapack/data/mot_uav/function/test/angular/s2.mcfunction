#mot_uav:test/angular/s2

# 指定左轴(红色向量)为新的角速度方向(相当于上下摆头)
function mot_uav:_get
scoreboard players operation angular_x int = ivec_x int
scoreboard players operation angular_y int = ivec_y int
scoreboard players operation angular_z int = ivec_z int
scoreboard players operation angular_x int *= 2 int
scoreboard players operation angular_y int *= 2 int
scoreboard players operation angular_z int *= 2 int
function mot_uav:angular/_update
function mot_uav:_store

# 状态2下一刻直接跳转到状态3
data modify storage marker_control:io result.state set value 3