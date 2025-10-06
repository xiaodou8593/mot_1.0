#mot_scatter:bullet/hurt
# mot_scatter:bullet/loop调用

execute at @s anchored eyes run particle minecraft:block_crumble{block_state:"minecraft:redstone_block"} ^ ^-0.5 ^ 0.2 0.2 0.2 0.05 1

execute store result score temp_hp int run data get entity @s Health 10
execute store result entity @s Health float 0.1 run scoreboard players remove temp_hp int 30

scoreboard players set res int 1