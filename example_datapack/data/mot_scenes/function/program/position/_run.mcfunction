#mot_scenes:program/position/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 获取水平偏移
scoreboard players operation damp_x int = x int
scoreboard players operation damp_z int = z int
scoreboard players operation damp_x int -= target_x int
scoreboard players operation damp_z int -= target_z int
scoreboard players set damp_y int 0

# 获取水平速度
scoreboard players operation damp_vx int = vx int
scoreboard players operation damp_vz int = vz int
scoreboard players set damp_vy int 0

scoreboard players operation temp_sf int = damp_f int
# 设置阻尼冲量参数
scoreboard players operation temp_r int = damp_x int
scoreboard players operation temp_r int /= 100 int
scoreboard players operation temp_r int *= temp_r int
scoreboard players operation sqrt int = damp_z int
scoreboard players operation sqrt int /= 100 int
scoreboard players operation sqrt int *= sqrt int
scoreboard players operation sqrt int += temp_r int
function math:sqrt/_self
scoreboard players operation sqrt int /= 4 int
scoreboard players operation damp_f int < sqrt int
scoreboard players operation damp_f int > 10 int

# 控制迭代
function math:damp_vec/_iter

scoreboard players set state int 1
# 抵达判定
function math:damp_vec/_energy
scoreboard players operation temp_e int = res int
function math:damp_vec/_threshold
scoreboard players operation res int *= 25 int
execute if score temp_e int <= res int run scoreboard players set state int 2

# 根据速度差值施加冲量
execute if score temp_e int > res int run function mot_scenes:program/position/apply_impulse
scoreboard players operation damp_f int = temp_sf int