#mot_uav:program/height/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 输入阻尼运动位置和速度
scoreboard players operation damp_x int = y int
scoreboard players operation damp_x int -= target_y int
scoreboard players operation damp_v int = vy int

scoreboard players operation temp_sf int = damp_f int

scoreboard players set state int 1
# 判定阻尼运动终止
function math:damp/_energy
scoreboard players operation temp_e int = res int
function math:damp/_threshold
execute if score temp_e int <= res int run return run scoreboard players set state int 2

# 设置阻尼冲量参数
scoreboard players set damp_m int 100
scoreboard players operation temp_f int = damp_x int
execute if score temp_f int matches ..-1 run scoreboard players operation temp_f int *= -1 int
scoreboard players operation temp_f int /= damp_m int
scoreboard players operation temp_f int > 1 int
scoreboard players operation damp_f int < temp_f int

# 阻尼迭代
scoreboard players operation temp_v int = damp_v int
function math:damp/_iter

# 输出机翼电机功率
scoreboard players operation damp_v int -= temp_v int
scoreboard players operation fans_power int = damp_v int
scoreboard players operation fans_power int += mot_uav_g int
scoreboard players operation fans_power int > 1 int

scoreboard players operation damp_f int = temp_sf int