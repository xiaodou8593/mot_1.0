#mot_mover:place_block
# mot_mover:_run调用

# 无法放置方块
execute unless block ~ ~ ~ #mot_uav:pass run return run playsound minecraft:block.note_block.banjo player @a ~ ~ ~ 1.0 2.0

# 放置方块
playsound minecraft:block.stone.place player @a ~ ~ ~ 1.0 1.5
function mot_mover:block/_place
function mot_mover:block/_zero