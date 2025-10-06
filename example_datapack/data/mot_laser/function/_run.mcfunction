#mot_laser:_run
# 运行激光设备

tag @s remove triggered

# 无剩余子弹
execute if score bullet_res int matches ..0 at @s run return run playsound minecraft:block.chest.locked player @a ~ ~ ~ 1.0 2.0
# 发射子弹
execute as 0-0-0-0-0 run function mot_laser:shoot_bullet