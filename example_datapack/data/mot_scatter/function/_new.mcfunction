#mot_scatter:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_scatter:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon item_display ~ ~ ~ {Tags:["mot_scatter", "result", "mot_device"],\
	item:{id:"minecraft:piston", count:1b},\
	transformation:{right_rotation:[0.7071f,0f,0f,0.7071f],scale:[0.75f,0.75f,0.75f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f]},\
	CustomName:'"mot_scatter"',\
	teleport_duration:1, interpolation_duration:1,\
	Passengers:[\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_0","barrel","local_quat"],CustomName:'"mot_scatter_barrel_0"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.1875f,1.0f,0.1875f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.375f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_1","barrel","local_quat"],CustomName:'"mot_scatter_barrel_1"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.1875f,1.0f,0.1875f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.375f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_2","barrel","local_quat"],CustomName:'"mot_scatter_barrel_2"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.1875f,1.0f,0.1875f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.375f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_3","barrel","local_quat"],CustomName:'"mot_scatter_barrel_3"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.1875f,1.0f,0.1875f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.375f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_4","barrel","local_quat"],CustomName:'"mot_scatter_barrel_4"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.1875f,1.0f,0.1875f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.375f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_5","barrel","local_quat"],CustomName:'"mot_scatter_barrel_5"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.1875f,1.0f,0.1875f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.375f]},interpolation_duration:1},\
	]\
}
execute as @e[tag=result,limit=1] on passengers run function mot_uav:set_uvw
execute as @e[tag=result,limit=1] run function mot_scatter:set
execute as @e[tag=result,limit=1] run function mot_scatter:set_operations