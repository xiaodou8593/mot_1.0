#mot_uav:test/move/start

# 生成测试程序实体
tag @e[tag=result] remove result
summon marker 0 0 0 {Tags:["test", "mot_uav_test", "result"], CustomName:'{"text":"mot_uav_test"}'}

execute as @e[tag=result,limit=1] run function marker_control:data/_get

# 设置测试程序主函数和销毁函数
data modify storage marker_control:io result.tick_func set value "mot_uav:test/move/main"
data modify storage marker_control:io result.del_func set value "mot_uav:test/move/end"

execute as @e[tag=result,limit=1] run function marker_control:data/_store
tag @e[tag=result,limit=1] add entity_ticked
tag @e[tag=result,limit=1] add entity_todel

# 设置测试程序运行时间
scoreboard players set @e[tag=result,limit=1] killtime 60

# 生成不同的移动方案
summon item_display 0.0 -54.5 0.0 {item:{id:"minecraft:red_wool", count:1b},Tags:["test", "test_move_1", "test_move"]}

summon item_display 0.0 -54.5 1.5 {item:{id:"minecraft:green_wool", count:1b},Tags:["test", "test_move_2", "test_move"], teleport_duration:1}

summon area_effect_cloud 0.0 -55.0 3.0 {Tags:["test", "upd_aec", "test_move_3", "test_move"], Duration:2147483647, Passengers:[{id:"minecraft:item_display", Tags:["test","test_move"], item:{id:"minecraft:blue_wool",count:1b}}]}

summon item_display 0.0 -54.5 4.5 {Tags:["test", "test_move_4", "test_move"], teleport_duration:1, Passengers:[{id:"minecraft:item_display", Tags:["test", "test_move"], item:{id:"minecraft:yellow_wool", count:1b}}]}

summon item_display 0.0 -54.5 6.0 {item:{id:"minecraft:cyan_wool", count:1b},Tags:["test", "test_move_5", "test_move"], Passengers:[{id:"minecraft:area_effect_cloud", Duration:2147483647, Tags:["upd_aec", "test", "test_move"]}]}