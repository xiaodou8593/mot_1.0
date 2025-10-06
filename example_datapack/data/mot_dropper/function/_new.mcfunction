#mot_dropper:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_dropper:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon item_display ~ ~ ~ {Tags:["mot_dropper", "result", "mot_device"],\
	item:{id:"minecraft:tripwire_hook", count:1b},\
	transformation:{right_rotation:[1f,0f,0f,0f],scale:[1f,1f,1f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f]},\
	CustomName:'"mot_dropper"',\
	teleport_duration:1, interpolation_duration:1,\
	Passengers:[\
		{id:"minecraft:block_display",Tags:["mot_dropper_display","block_0","block"],CustomName:'"mot_dropper_block_0"',transformation:{right_rotation:[0f,0f,0f,1f],scale:[1f,1f,1f],left_rotation:[0f,0f,0f,1f],translation:[-0.5f,-1.125f,-0.5f]},interpolation_duration:1}\
	]\
}
execute as @e[tag=result,limit=1] on passengers run function mot_uav:set_uvw
execute as @e[tag=result,limit=1] run function mot_dropper:set
execute as @e[tag=result,limit=1] run function mot_dropper:set_operations