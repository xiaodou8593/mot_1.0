#mot_uav:test/program/start

# 生成测试程序实体
data modify storage mot_uav:io input set from storage mot_uav:class test
function mot_uav:_new

execute as @e[tag=result,limit=1] run function marker_control:data/_get

# 控制程序管线
data modify storage marker_control:io result.lst_programs set value []
# 上升5格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"up"}]
data modify storage marker_control:io result.lst_programs[-1].delta_y set value 5.0d
# 左转45度
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"turn"}]
data modify storage marker_control:io result.lst_programs[-1].delta_theta set value 45.0d
data remove storage marker_control:io result.lst_programs[-1].target_y
# 前进10格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"forward"}]
data modify storage marker_control:io result.lst_programs[-1].w set value 10.0d
data remove storage marker_control:io result.lst_programs[-1].target_y
# 降落到地面
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"landing"}]
# 结束测试
data modify storage marker_control:io result.lst_programs append value {}

# 设置测试程序主函数和销毁函数
data modify storage marker_control:io result.tick_func set value "mot_uav:test/program/main"
data modify storage marker_control:io result.del_func set value "mot_uav:test/program/end"

execute as @e[tag=result,limit=1] run function marker_control:data/_store
tag @e[tag=result,limit=1] add entity_ticked
tag @e[tag=result,limit=1] add entity_todel

# 设置测试程序运行时间
scoreboard players set @e[tag=result,limit=1] killtime 500