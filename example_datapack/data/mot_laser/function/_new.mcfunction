#mot_laser:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_laser:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon item_display ~ ~ ~ {Tags:["mot_laser", "result", "mot_device"],\
	item:{id:"minecraft:piston", count:1b},\
	transformation:{right_rotation:[0.7071f,0f,0f,0.7071f],scale:[0.25f,0.25f,0.25f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f]},\
	CustomName:'"mot_laser"',\
	teleport_duration:1, interpolation_duration:1,\
	Passengers:[\
		{id:"minecraft:item_display",Tags:["mot_laser_display","barrel_0","barrel"],CustomName:'"mot_laser_barrel_0"',item:{id:"minecraft:end_rod",count:1b},transformation:{right_rotation:[0.7071f,0f,0f,0.7071f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.375f]},interpolation_duration:1}\
	]\
}
execute as @e[tag=result,limit=1] on passengers run function mot_uav:set_uvw
execute as @e[tag=result,limit=1] run function mot_laser:set
execute as @e[tag=result,limit=1] run function mot_laser:set_operations