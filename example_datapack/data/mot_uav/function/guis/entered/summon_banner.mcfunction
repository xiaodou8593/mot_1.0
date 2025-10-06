#mot_uav:guis/entered/summon_banner
# mot_uav:guis/entered/button_3调用

# 视线追踪获取落点
function iframe:ray/_anchor_to
function iframe:ray/_if_solid
execute if score iframe_ray_res int matches 0 run return fail

# 生成旗帜展示实体
tag @e[tag=result] remove result
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get iframe_ray_ix int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players get iframe_ray_iy int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get iframe_ray_iz int
data modify entity @s Pos set from storage math:io xyz
execute at @s run summon minecraft:item_display ~ ~ ~ {item:{id:"minecraft:red_banner",count:1b},Tags:["result"],transformation:{left_rotation:[0.0f,0.0f,0.0f,1.0f],scale:[0.0f,0.0f,0.0f],right_rotation:[0.0f,0.0f,0.0f,1.0f],translation:[0.0f,0.5f,0.0f]}}
tp @s 0 0 0 ~ ~
execute store result score theta int run data get entity @s Rotation[0] -10000
function math:iquat/_theta_to
function math:iquat/_model
data modify entity @e[tag=result,limit=1] transformation.left_rotation set from storage math:io xyzw
data modify entity @e[tag=result,limit=1] transformation.scale set value [1.0f,1.0f,1.0f]
scoreboard players set @e[tag=result,limit=1] killtime 50