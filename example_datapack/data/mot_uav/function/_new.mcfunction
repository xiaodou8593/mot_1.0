#mot_uav:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_uav:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon item_display ~ ~ ~ {Tags:["mot_uav", "result"],\
	item:{id:"minecraft:observer", count:1b},\
	transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f]},\
	teleport_duration:1, interpolation_duration:1,\
	Passengers:[\
		{id:"minecraft:block_display",Tags:["mot_uav_display","torch"],block_state:{Name:"minecraft:redstone_torch",Properties:{lit:"true"}},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],translation:[-0.25f,0.25f,-0.25f]},interpolation_duration:1,brightness:{sky:15, block:15}},\
		{id:"minecraft:item_display",Tags:["mot_uav_display","fan_0"],item:{id:"minecraft:heavy_weighted_pressure_plate",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.2f,0.5f,1.2f],left_rotation:[0f,0f,0f,1f],translation:[0f,0.6f,0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_uav_display","fan_1"],item:{id:"minecraft:heavy_weighted_pressure_plate",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[1.2f,0.5f,0.2f],left_rotation:[0f,0f,0f,1f],translation:[0f,0.6f,0f]},interpolation_duration:1},\
	]\
}
execute as @e[tag=result,limit=1] on passengers run function mot_uav:set_uvw
execute as @e[tag=result,limit=1] run function mot_uav:set