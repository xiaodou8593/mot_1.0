#mot_dropper:grab_block
# mot_dropper:_run调用

# 尝试读取方块
function mot_mover:block/_read
# 如果不是tnt方块则读取失败
execute unless data storage mot_mover:io {block_id:"minecraft:tnt"} run function mot_mover:block/_zero
# 读取失败则直接返回
execute if data storage mot_mover:io {block_id:""} run return run playsound minecraft:block.iron_door.close player @a ~ ~ ~ 1.0 1.5

# 挖掘方块效果
data modify block ~ ~ ~ Items set value []
execute store result score temp int run gamerule doTileDrops
gamerule doTileDrops false
setblock ~ ~ ~ air destroy
execute if score temp int matches 1 run gamerule doTileDrops true