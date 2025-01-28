#mot_uav:angular/_factor
# 输入<inp, int, 1w>表示缩放因子

# 缩放角速度向量
scoreboard players operation angular_x int *= inp int
scoreboard players operation angular_x int /= 10000 int
scoreboard players operation angular_y int *= inp int
scoreboard players operation angular_y int /= 10000 int
scoreboard players operation angular_z int *= inp int
scoreboard players operation angular_z int /= 10000 int

# 计算新的模长
scoreboard players operation angular_len int *= inp int
scoreboard players operation angular_len int /= 10000 int