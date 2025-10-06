#mot_scatter:main
# mot_scatter:tick调用
# 实体对象主程序

function mot_scatter:_get

scoreboard players operation tempid int = @s mot_uav_root
execute if score tempid int matches 0 run function mot_uav:device/_main_motion
execute if score tempid int matches 1.. if function mot_scatter:sync_uvw run function mot_uav:device/_main_sync
execute if entity @s[tag=triggered] run function mot_scatter:_run

function mot_scatter:_store

# 坐标安全
execute unless score y int matches -640000..5120000 run function mot_uav:_del