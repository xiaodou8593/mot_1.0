#mot_uav:set_operations
# mot_uav:_new调用

# 同步机翼电机开关
function mot_uav:fans/update_torch

# 初始化本地四元数
execute on passengers if entity @s[tag=local_quat] run scoreboard players set @s iquat_w 10000

# 获取无人机编号
function mot_uav:_new_id
scoreboard players operation @s mot_uav_id = res int

# 获取模块编号
scoreboard players operation @s module_id = #mot_uav: module_id

# 初始化为iframe_box对象
function iframe:box/_prescript