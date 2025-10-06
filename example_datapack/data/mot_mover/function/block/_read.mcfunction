#mot_mover:block/_read
# 读取方块数据
# 输入执行位置

# 数据置空
data modify storage mot_mover:io block_id set value ""
data modify storage mot_mover:io block_state set value {}
data modify storage mot_mover:io block_nbt set value {}

# 决定读取哪些方块状态、是否读取NBT
scoreboard players set temp_state_0 int 0
scoreboard players set temp_state_1 int 0
scoreboard players set temp_nbt int 0
execute store result score res int run loot replace entity 0-0-0-0-2 container.0 mine ~ ~ ~ minecraft:golden_pickaxe[minecraft:enchantments={levels:{"minecraft:silk_touch":1}}]
execute if score res int matches 1 run data modify storage mot_mover:io block_id set from entity 0-0-0-0-2 item.id

# 加载特殊方块数据
data modify storage mot_mover:io func_name set string storage mot_mover:io block_id 10
function mot_mover:block/search with storage mot_mover:io {}

# 读取方块状态
execute if score temp_state_0 int matches 1 run function mot_mover:block/read_state_0
execute if score temp_state_1 int matches 1 run function mot_mover:block/read_state_1

# 读取NBT
execute if score temp_nbt int matches 1 run data modify storage mot_mover:io block_nbt set from block ~ ~ ~ {}