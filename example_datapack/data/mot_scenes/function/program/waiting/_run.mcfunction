#mot_scenes:program/waiting/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

scoreboard players set state int 1
execute if score wait_time int matches 1.. run scoreboard players remove wait_time int 1
execute if score wait_time int matches 0 run scoreboard players set state int 2