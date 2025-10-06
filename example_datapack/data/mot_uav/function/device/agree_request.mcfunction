#mot_uav:device/agree_request
# mot_uav:device/_sync_request调用

# 设置连接
scoreboard players operation @s mot_uav_root = inp int

# 保存插槽类型
data modify entity @s item.components."minecraft:custom_data".slot_type set from storage mot_uav:io slot_type

# 返回自身编号
scoreboard players operation res int = @s mot_uav_id