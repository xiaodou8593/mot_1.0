#mot_laser:bullet/hurt
# mot_laser:bullet/loop调用

execute store result score temp_hp int run data get entity @s Health 10
execute store result entity @s Health float 0.1 run scoreboard players remove temp_hp int 100