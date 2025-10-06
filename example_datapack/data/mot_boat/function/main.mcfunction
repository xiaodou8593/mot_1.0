#mot_boat:main
# mot_boat:tick调用
# 实体对象主程序

function mot_boat:_get

scoreboard players operation tempid int = @s mot_uav_root
execute if score tempid int matches 0 run function mot_boat:main_motion
execute if score tempid int matches 1.. run function mot_boat:main_sync
execute if entity @s[tag=triggered] run function mot_boat:_run

function mot_boat:_store