#mot_laser:shoot_bullet
# mot_laser:_run调用

# 获取发射位置
scoreboard players set u int 0
scoreboard players set v int 0
scoreboard players set w int 6250
function math:uvw/_topos

# 播放音效
execute at @s run playsound minecraft:entity.evoker.cast_spell player @a ~ ~ ~ 1.0 2.0

# 生成子弹
data modify storage mot_laser:io input set from storage mot_scatter:class test_bullet
data modify storage mot_laser:io input.position set from entity @s Pos
execute store result storage mot_laser:io input.kvec[0] double 0.0001 run scoreboard players get kvec_x int
execute store result storage mot_laser:io input.kvec[1] double 0.0001 run scoreboard players get kvec_y int
execute store result storage mot_laser:io input.kvec[2] double 0.0001 run scoreboard players get kvec_z int
function mot_laser:bullet/_new

scoreboard players remove bullet_res int 20