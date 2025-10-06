#mot_laser:cooldown
# mot_laser:main调用

scoreboard players add bullet_res int 1
execute if score bullet_res int matches 1 at @s run playsound minecraft:block.note_block.banjo player @a ~ ~ ~ 1.0 2.0