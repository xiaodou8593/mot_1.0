#mot_uav:_controller
# 生成控制权限物品
# 以实体对象为执行者
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
execute at @s run summon item ~ ~ ~ {\
	Item:{id:"minecraft:tripwire_hook",count:1b},\
	Motion:[0.0d,0.2d,0.1d],\
	Tags:["result"]\
}

data modify storage mot_uav:io temp set value {mot_uav:"controller",mot_uav_id:0}
execute store result storage mot_uav:io temp.mot_uav_id int 1 run scoreboard players get @s mot_uav_id
data modify entity @e[tag=result,limit=1] Item.components."minecraft:custom_data" set from storage mot_uav:io temp

scoreboard players operation temp int = @s mot_uav_id
data modify storage mot_uav:io input set value '[{"text":"mot_uav_","color":"red","italic":false},{"score":{"name":"temp","objective":"int"}},{"text":"控制权限"}]'
item modify entity 0-0-0-0-1 container.0 mot_uav:_interpret
data modify entity @e[tag=result,limit=1] Item.components."minecraft:custom_name" set from entity 0-0-0-0-1 Item.components."minecraft:lore"[0]