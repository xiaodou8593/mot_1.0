#mot_uav:_consts
# 创建常量

# 质量
scoreboard players set mot_uav_m int 20

# 速度阻尼
scoreboard players set mot_uav_k int 9800

# 重力加速度
scoreboard players set mot_uav_g int 200

# 弹性系数
scoreboard players set mot_uav_b int 8500

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