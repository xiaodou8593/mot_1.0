#mot_uav:test/facing/start

# 生成测试程序实体
function mot_scatter:_init
data modify storage mot_scatter:io input set from storage mot_scatter:class test
function mot_scatter:_new
tag @e[tag=result,limit=1] add test_device
data modify storage mot_uav:io input set from storage mot_uav:class test
function mot_uav:_new

execute as @e[tag=result,limit=1] run function marker_control:data/_get

# 控制程序管线
data modify storage marker_control:io result.lst_programs set value []
# 上升1格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"up"}]
data modify storage marker_control:io result.lst_programs[-1].delta_y set value 1.0d
# 下降2.8格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"up"}]
data modify storage marker_control:io result.lst_programs[-1].delta_y set value -2.8d
# 右偏1.0格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"forward"}]
data modify storage marker_control:io result.lst_programs[-1].u set value -1.0d
data remove storage marker_control:io result.lst_programs[-1].target_y
# 下降0.5格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"up"}]
data modify storage marker_control:io result.lst_programs[-1].delta_y set value -0.5d
# 连接设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"left_connect"}]
# 装填子弹
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"left_use"}]
# 上升1.5格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"up"}]
data modify storage marker_control:io result.lst_programs[-1].delta_y set value 1.5d
# 旋转并射击
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"compose"}]
data modify storage marker_control:io result.lst_programs[-1].list_programs append from storage mot_uav:class default_programs[{id:"turn"}]
data modify storage marker_control:io result.lst_programs[-1].list_programs[-1].delta_theta set value -90.0d
data remove storage marker_control:io result.lst_programs[-1].list_programs[-1].target_y
data modify storage marker_control:io result.lst_programs[-1].list_programs append from storage mot_uav:class default_programs[{id:"left_use"}]
# 下降0.5格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"up"}]
data modify storage marker_control:io result.lst_programs[-1].delta_y set value -0.5d
# 左移并射击
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"compose"}]
data modify storage marker_control:io result.lst_programs[-1].list_programs append from storage mot_uav:class default_programs[{id:"forward"}]
data modify storage marker_control:io result.lst_programs[-1].list_programs[-1].u set value 5.0d
data remove storage marker_control:io result.lst_programs[-1].list_programs[-1].target_y
data modify storage marker_control:io result.lst_programs[-1].list_programs append from storage mot_uav:class default_programs[{id:"left_use"}]
# 等待
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"waiting"}]
# 结束标记
data modify storage marker_control:io result.lst_programs append value {}

# 设置测试程序主函数和销毁函数
data modify storage marker_control:io result.tick_funcs set value ["mot_uav:test/facing/main","mot_uav:test/program/main"]
data modify storage marker_control:io result.del_func set value "mot_uav:test/facing/end"

execute as @e[tag=result,limit=1] run function marker_control:data/_store
tag @e[tag=result,limit=1] add entity_ticked
tag @e[tag=result,limit=1] add entity_todel

# 设置测试程序运行时间
scoreboard players set @e[tag=result,limit=1] killtime 500