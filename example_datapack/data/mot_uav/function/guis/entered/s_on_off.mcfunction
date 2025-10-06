#mot_uav:guis/entered/s_on_off

execute store result score tempid int run data get storage iframe:io result.mot_uav_id
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run tag @s add tmp
scoreboard players operation fans_power int = @e[tag=tmp,limit=1] fans_power

# 上传空程序
execute as @e[tag=tmp,limit=1] run function mot_uav:_get
data modify storage mot_uav:io program set value {}
execute as @e[tag=tmp,limit=1] run function mot_uav:_store

# 切换电机状态
execute if score fans_power int matches 0 as @e[tag=tmp,limit=1] run function mot_uav:fans/_on
execute if score fans_power int matches 1.. as @e[tag=tmp,limit=1] run function mot_uav:fans/_off

tag @e[tag=tmp] remove tmp
scoreboard players set update_gui int 1