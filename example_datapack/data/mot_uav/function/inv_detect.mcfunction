#mot_uav:inv_detect
# mot_uav:tick调用

# 缓存玩家物品栏
data modify storage mot_uav:io inv set from entity @s Inventory

# 检测控制权限
execute store success score res int run tag @s remove mot_uav_player
execute if data storage mot_uav:io \
	inv[].components."minecraft:custom_data"{mot_uav:"controller"} \
	run tag @s add mot_uav_player
# 解除视线追踪服务
execute if score res int matches 1 unless entity @s[tag=mot_uav_player] \
	run function iframe:ray/_unbe

tag @s remove mot_uav_inv_c
advancement revoke @s only mot_uav:inv_c