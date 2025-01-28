#mot_uav:test/angular/s0

# 赋予角速度
function mot_uav:_get
scoreboard players set angular_x int 10000
scoreboard players set angular_y int 10000
scoreboard players set angular_z int 10000
function mot_uav:angular/_update
function mot_uav:_store

# 状态0的下一刻直接跳转到状态1
data modify storage marker_control:io result.state set value 1