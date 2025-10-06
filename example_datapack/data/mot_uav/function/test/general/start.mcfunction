#mot_uav:test/general/start

# 生成测试程序实体
data modify storage mot_uav:io input set from storage mot_uav:class test
function mot_uav:_new
tag @e[tag=result,limit=1] add test

execute as @e[tag=result,limit=1] run function marker_control:data/_get

# 设置测试程序主函数和销毁函数
data modify storage marker_control:io result.tick_func set value "mot_uav:test/general/main"
data modify storage marker_control:io result.del_func set value "mot_uav:test/general/end"

execute as @e[tag=result,limit=1] run function marker_control:data/_store
tag @e[tag=result,limit=1] add entity_ticked
tag @e[tag=result,limit=1] add entity_todel

# 设置测试程序运行时间
scoreboard players set @e[tag=result,limit=1] killtime 20

scoreboard players set test int 0

# debug
#execute as @e[tag=result,limit=1] run function mot_uav:main
#execute as @e[tag=result,limit=1] run function mot_uav:_del