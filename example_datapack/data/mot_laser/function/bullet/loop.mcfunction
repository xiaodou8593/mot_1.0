#mot_laser:bullet/loop
# mot_laser:bullet/main调用

particle minecraft:end_rod ~ ~ ~
execute as @e[dx=0,dy=0,dz=0] positioned ~-0.999 ~-0.999 ~-0.999 if entity @s[dx=0,dy=0,dz=0] run function mot_laser:bullet/hurt

scoreboard players remove loop int 1
execute if score loop int matches ..0 positioned ^ ^ ^0.1 run tp @s ~ ~ ~
execute if score loop int matches 1.. positioned ^ ^ ^0.1 run function mot_laser:bullet/loop