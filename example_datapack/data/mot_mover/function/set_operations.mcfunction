#mot_mover:set_operations
# mot_mover:_new调用

# 更新展示实体
function mot_mover:block/_get
function mot_mover:update_block

# 获取设备编号
function mot_uav:_new_id
scoreboard players operation @s mot_uav_id = res int

# 获取模块编号
scoreboard players operation @s module_id = #mot_mover: module_id