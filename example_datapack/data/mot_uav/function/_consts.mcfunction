#mot_uav:_consts
# 创建常量

# 质量
scoreboard players set mot_uav_m int 20

# 速度阻尼
scoreboard players set mot_uav_k int 9800

# 角速度阻尼
scoreboard players set mot_uav_ak int 9800

# 重力加速度
scoreboard players set mot_uav_g int 200

# 弹性系数
scoreboard players set mot_uav_b int 6500

# 着陆能量阈值
scoreboard players set mot_uav_st int 2560000

# 着陆角度修正阈值
scoreboard players set mot_uav_sa int 700

# 着陆底盘距离
scoreboard players set mot_uav_ch int 2500

# 着陆速度阻尼
scoreboard players set mot_uav_ek int 9100

# 机翼电机转动速率
scoreboard players set mot_uav_fr int 850

# 机翼角速度阻尼阈值
scoreboard players set mot_uav_ft int 100

# 机翼角速度阻尼系数
scoreboard players set mot_uav_fk int 9300

# 机翼角速度阻尼冲量
scoreboard players set mot_uav_ff int 350

# 机翼角速度阻尼惯量
scoreboard players set mot_uav_fm int 100

# 碰撞点列表
data modify storage mot_uav:io collision_points set value [\
	[-0.25d, -0.25d, -0.25d],\
	[-0.25d, -0.25d, 0.25d],\
	[-0.25d, 0.25d, -0.25d],\
	[-0.25d, 0.25d, 0.25d],\
	[0.25d, -0.25d, -0.25d],\
	[0.25d, -0.25d, 0.25d],\
	[0.25d, 0.25d, -0.25d],\
	[0.25d, 0.25d, 0.25d]\
]