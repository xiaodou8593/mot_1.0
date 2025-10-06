#mot_lamp:collision/_load_data
# 加载红石灯碰撞数据

# 着陆底盘距离
scoreboard players set mot_uav_ch int 1250

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

# 是否加载完成
return 1