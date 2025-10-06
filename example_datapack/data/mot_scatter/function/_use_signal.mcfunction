#mot_scatter:_use_signal
# 输出<res,int>, 使用结束?1:0

scoreboard players set res int 0
execute if score @s bullet_res matches ..0 run scoreboard players set res int 1
tag @s add triggered