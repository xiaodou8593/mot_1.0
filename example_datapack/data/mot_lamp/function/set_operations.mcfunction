#mot_lamp:set_operations
# mot_lamp:_new调用

# 进入关闭状态
function mot_lamp:_off

# 获取设备编号
function mot_uav:_new_id
scoreboard players operation @s mot_uav_id = res int

# 获取模块编号
scoreboard players operation @s module_id = #mot_lamp: module_id