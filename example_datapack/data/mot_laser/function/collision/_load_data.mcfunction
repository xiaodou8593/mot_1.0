#mot_laser:collision/_load_data
# 加载机枪碰撞数据

# 碰撞点列表
data modify storage mot_uav:io collision_points set value [\
	[-0.125d, -0.125d, -0.125d],\
	[-0.125d, -0.125d, 0.125d],\
	[-0.125d, 0.125d, -0.125d],\
	[-0.125d, 0.125d, 0.125d],\
	[0.125d, -0.125d, -0.125d],\
	[0.125d, -0.125d, 0.125d],\
	[0.125d, 0.125d, -0.125d],\
	[0.125d, 0.125d, 0.125d]\
]

scoreboard players set mot_uav_ch int 1250

# 是否加载完成
return 1