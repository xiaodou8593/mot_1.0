#mot_mover:block/_get
# 数据临时化
# 以实例为执行者

data modify storage mot_mover:io block_id set from entity @s item.components."minecraft:custom_data".block_id
data modify storage mot_mover:io block_state set from entity @s item.components."minecraft:custom_data".block_state
data modify storage mot_mover:io block_nbt set from entity @s item.components."minecraft:custom_data".block_nbt