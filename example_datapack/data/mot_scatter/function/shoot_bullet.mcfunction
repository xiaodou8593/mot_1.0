#mot_scatter:shoot_bullet
# mot_scatter:_run调用

# 获取发射位置
scoreboard players set u int 0
scoreboard players set v int 2250
scoreboard players set w int 11250
function math:uvw/_topos

# 播放音效
scoreboard players operation temp_mod int = bullet_res int
scoreboard players operation temp_mod int %= 2 int
execute if score temp_mod int matches 0 at @s run playsound minecraft:entity.firework_rocket.blast player @a ~ ~ ~ 1.0 1.5

# 播放粒子
execute at @s run particle flame ~ ~ ~ 0.0 0.0 0.0 0.01 1

# 生成子弹
data modify storage mot_scatter:io input set from storage mot_scatter:class test_bullet
data modify storage mot_scatter:io input.position set from entity @s Pos
execute store result storage mot_scatter:io input.kvec[0] double 0.0001 run scoreboard players get kvec_x int
execute store result storage mot_scatter:io input.kvec[1] double 0.0001 run scoreboard players get kvec_y int
execute store result storage mot_scatter:io input.kvec[2] double 0.0001 run scoreboard players get kvec_z int
function mot_scatter:bullet/_new

scoreboard players remove bullet_res int 1