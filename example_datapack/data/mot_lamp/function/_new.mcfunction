#mot_lamp:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_lamp:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon item_display ~ ~ ~ {Tags:["mot_lamp", "result", "mot_device"],\
	item:{id:"minecraft:redstone",count:1b},\
	transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0f,0.0f,0.0f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f]},\
	CustomName:'"mot_lamp"',\
	teleport_duration:1, interpolation_duration:1,\
	Passengers:[\
		{id:"minecraft:block_display",Tags:["mot_lamp_display","lamp"],CustomName:'"mot_lamp_display"',block_state:{Name:"minecraft:redstone_lamp",Properties:{lit:"true"}},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.25f,0.25f,0.25f],left_rotation:[0f,0f,0f,1f],translation:[-0.125f,-0.125f,-0.125f]},interpolation_duration:1,brightness:{sky:15, block:15}}\
	]\
}
execute as @e[tag=result,limit=1] on passengers run function mot_uav:set_uvw
execute as @e[tag=result,limit=1] run function mot_lamp:set
execute as @e[tag=result,limit=1] run function mot_lamp:set_operations