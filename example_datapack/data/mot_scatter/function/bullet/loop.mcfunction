#mot_scatter:bullet/loop
# mot_scatter:bullet/main调用

particle minecraft:crit ~ ~ ~
execute as @e[dx=0,dy=0,dz=0] positioned ~-0.999 ~-0.999 ~-0.999 if entity @s[dx=0,dy=0,dz=0] run function mot_scatter:bullet/hurt
execute positioned ^ ^ ^0.1 as @e[dx=0,dy=0,dz=0] positioned ~-0.999 ~-0.999 ~-0.999 if entity @s[dx=0,dy=0,dz=0] run function mot_scatter:bullet/hurt
execute positioned ^ ^ ^0.2 as @e[dx=0,dy=0,dz=0] positioned ~-0.999 ~-0.999 ~-0.999 if entity @s[dx=0,dy=0,dz=0] run function mot_scatter:bullet/hurt
execute positioned ^ ^ ^0.3 as @e[dx=0,dy=0,dz=0] positioned ~-0.999 ~-0.999 ~-0.999 if entity @s[dx=0,dy=0,dz=0] run function mot_scatter:bullet/hurt
execute positioned ^ ^ ^0.4 as @e[dx=0,dy=0,dz=0] positioned ~-0.999 ~-0.999 ~-0.999 if entity @s[dx=0,dy=0,dz=0] run function mot_scatter:bullet/hurt
execute unless block ~ ~ ~ #mot_uav:pass run scoreboard players set res int 1
execute if score res int matches 1 run return run scoreboard players set @s killtime 0

scoreboard players remove loop int 1
execute if score loop int matches ..0 positioned ^ ^ ^0.5 run tp @s ~ ~ ~
execute if score loop int matches 1.. positioned ^ ^ ^0.5 run function mot_scatter:bullet/loop