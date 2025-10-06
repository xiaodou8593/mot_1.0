#mot_boat:set_operations
# mot_boat:_new调用

# 获取设备编号
function mot_uav:_new_id
scoreboard players operation @s mot_uav_id = res int

# 获取模块编号
scoreboard players operation @s module_id = #mot_boat: module_id