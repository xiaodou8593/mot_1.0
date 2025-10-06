#mot_uav:test/program/upload_program
# mot_uav:test/program/main调用

execute unless data storage mot_uav:io program.target_y run scoreboard players operation test_y int = @s y

# 维持原程序高度
execute if data storage mot_uav:io program.target_y store result score test_y int run data get storage mot_uav:io program.target_y 10000

# 上传新程序
data modify storage mot_uav:io program set from storage marker_control:io result.lst_programs[0]
data remove storage marker_control:io result.lst_programs[0]
function marker_control:data/_store
execute unless data storage mot_uav:io program.target_y \
	store result storage mot_uav:io program.target_y double 0.0001 run \
	scoreboard players get test_y int
execute if data storage mot_uav:io program.list_programs[0] \
	store result storage mot_uav:io program.list_programs[].target_y double 0.0001 run \
	scoreboard players get test_y int
data modify storage mot_uav:io program.state set value 1
tellraw @a ["pointer: ", {"nbt":"program.pointer","storage":"mot_uav:io"}]
function mot_uav:_store_program

# 关闭机翼电机
execute unless data storage mot_uav:io program.pointer run \
	function mot_uav:fans/_off