#mot_uav:test/fans/start

# 生成测试程序实体
data modify storage mot_uav:io input set from storage mot_uav:class test
function mot_uav:_new

execute as @e[tag=result,limit=1] run function marker_control:data/_get

# 设置测试程序主函数和销毁函数
data modify storage marker_control:io result.tick_func set value "mot_uav:test/fans/main"
data modify storage marker_control:io result.del_func set value "mot_uav:test/fans/end"

execute as @e[tag=result,limit=1] run function marker_control:data/_store
tag @e[tag=result,limit=1] add entity_ticked
tag @e[tag=result,limit=1] add entity_todel

# 设置测试程序运行时间
scoreboard players set @e[tag=result,limit=1] killtime 300

# 打开机翼电机
execute as @e[tag=result,limit=1] run function mot_uav:fans/_on
execute as @e[tag=result,limit=1] run function mot_uav:_get
scoreboard players operation fans_power int = mot_uav_g int
execute as @e[tag=result,limit=1] run function mot_uav:_store