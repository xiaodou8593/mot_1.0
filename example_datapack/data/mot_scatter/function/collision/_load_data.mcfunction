#mot_scatter:collision/_load_data
# 加载机枪碰撞数据

# 碰撞点列表
data modify storage mot_uav:io collision_points set value [\
	[-0.375d, -0.375d, -0.375d],\
	[-0.375d, -0.375d, 0.375d],\
	[-0.375d, 0.375d, -0.375d],\
	[-0.375d, 0.375d, 0.375d],\
	[0.375d, -0.375d, -0.375d],\
	[0.375d, -0.375d, 0.375d],\
	[0.375d, 0.375d, -0.375d],\
	[0.375d, 0.375d, 0.375d]\
]

# 底盘距离
scoreboard players set mot_uav_ch int 3750

# 是否加载完成
return 1