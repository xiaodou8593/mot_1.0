#mot_boat:test/display/start

tag @e[tag=test] remove test
# 生成设备
data modify storage mot_boat:io input set from storage mot_boat:class test
execute positioned 8 -59 8 run function mot_boat:_new
tag @e[tag=result,limit=1] add test
# 生成测试程序实体
tag @e[tag=result] remove result
summon marker 0 0 0 {Tags:["test", "mot_boat_test", "result"], CustomName:'{"text":"mot_boat_test"}'}

execute as @e[tag=result,limit=1] run function marker_control:data/_get

# 设置测试程序主函数和销毁函数
data modify storage marker_control:io result.tick_func set value "mot_boat:test/display/main"
data modify storage marker_control:io result.del_func set value "mot_boat:test/display/end"

execute as @e[tag=result,limit=1] run function marker_control:data/_store
tag @e[tag=result,limit=1] add entity_ticked
tag @e[tag=result,limit=1] add entity_todel

# 设置测试程序运行时间
scoreboard players set @e[tag=result,limit=1] killtime 10
scoreboard players set test int 0