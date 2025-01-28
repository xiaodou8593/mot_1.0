#mot_uav:angular/_update

# 把当前四元数姿态设置为旋转的初始姿态
function math:quat/_topose

# 计算角速度的单位向量和模长
scoreboard players operation vec_x int = angular_x int
scoreboard players operation vec_y int = angular_y int
scoreboard players operation vec_z int = angular_z int
function math:vec/_unit_sqrt
scoreboard players operation angular_len int = res int
scoreboard players operation angular_len int *= 10 int

# 用单位向量指定四元数旋转轴
function math:quat/axis/_uvecto

# 初始旋转角为0
scoreboard players set quat_phi int 0