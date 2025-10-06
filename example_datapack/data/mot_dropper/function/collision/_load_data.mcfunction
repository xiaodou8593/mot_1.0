#mot_dropper:collision/_load_data
# 加载搬运器碰撞数据

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

execute unless data storage mot_mover:io {block_id:""} run \
	data modify storage mot_uav:io collision_points set value [\
	[-0.5d, -1.125d, -0.5d],\
	[-0.5d, -1.125d, 0.5d],\
	[-0.5d, -0.125d, -0.5d],\
	[-0.5d, -0.125d, 0.5d],\
	[0.5d, -1.125d, -0.5d],\
	[0.5d, -1.125d, 0.5d],\
	[0.5d, -0.125d, -0.5d],\
	[0.5d, -0.125d, 0.5d]\
]

execute unless data storage mot_mover:io {block_id:""} run \
	scoreboard players set mot_uav_ch int 11250

# 是否加载完成
return 1