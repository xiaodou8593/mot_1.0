#mot_dropper:_run
# 运行搬运器

tag @s remove triggered

# 获取抓取点
scoreboard players set u int 0
scoreboard players set v int -6250
scoreboard players set w int 0
execute as 0-0-0-0-0 run function math:uvw/_topos

# 选择分支
execute store result score temp_branch int unless data storage mot_mover:io {block_id:""}
execute if score temp_branch int matches 0 as 0-0-0-0-0 at @s run function mot_dropper:grab_block
execute if score temp_branch int matches 1 as 0-0-0-0-0 at @s run function mot_dropper:place_block

# 更新展示实体
function mot_dropper:update_block