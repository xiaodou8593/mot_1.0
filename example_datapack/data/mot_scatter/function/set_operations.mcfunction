#mot_scatter:set_operations
# mot_scatter:_new调用

# 初始化枪管相位角
scoreboard players set temp_phi int -600000
execute on passengers store result score @s scatter_phi run scoreboard players add temp_phi int 600000

# 更新枪管状态
function mot_scatter:update_barrel

# 获取设备编号
function mot_uav:_new_id
scoreboard players operation @s mot_uav_id = res int

# 获取模块编号
scoreboard players operation @s module_id = #mot_scatter: module_id