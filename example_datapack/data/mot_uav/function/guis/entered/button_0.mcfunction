#mot_uav:guis/entered/button_0

# 获取无人机
execute store result score tempid int run data get storage iframe:io result.mot_uav_id
scoreboard players set res int 0
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run tag @s add tmp

# 获取无人机当前高度
scoreboard players operation tempy int = @e[tag=tmp,limit=1] y

# 根据按钮状态设置目标高度
scoreboard players set temp_dy int 5000
execute if data storage iframe:io result{button_0:"down"} run scoreboard players operation temp_dy int *= -1 int

# 上传无人机上升/下降控制程序
execute as @e[tag=tmp,limit=1] run function mot_uav:_get
data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"height"}]
execute store result storage mot_uav:io program.target_y double 0.0001 run scoreboard players operation tempy int += temp_dy int
execute as @e[tag=tmp,limit=1] run function mot_uav:_store

tag @e[tag=tmp] remove tmp