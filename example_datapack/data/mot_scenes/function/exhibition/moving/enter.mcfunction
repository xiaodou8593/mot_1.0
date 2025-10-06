#mot_scenes:exhibition/moving/enter
# 进入运动状态

# 创建复合程序
data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"compose"}]

# 添加高度程序
scoreboard players operation temp_y int = @e[tag=test,tag=mot_uav,limit=1] y
execute if data storage mot_scenes:io input.target_pos \
	store result score temp_y int run \
	data get storage mot_scenes:io input.target_pos[1] 10000
data modify storage mot_uav:io program.list_programs append from storage mot_uav:class default_programs[{id:"height"}]
execute store result storage mot_uav:io program.list_programs[-1].target_y double 0.0001 run scoreboard players get temp_y int

# 添加水平位移程序
execute if data storage mot_scenes:io input.target_pos run function mot_scenes:exhibition/moving/append_position

# 添加水平旋转程序
execute if data storage mot_scenes:io input.target_theta run function mot_scenes:exhibition/moving/append_rotation

# 上传程序
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_store_program

# 状态切换
data modify storage marker_control:io result.state set value "moving"