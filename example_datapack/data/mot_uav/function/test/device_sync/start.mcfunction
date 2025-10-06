#mot_uav:test/device_sync/start

# 生成测试程序实体
function mot_lamp:_init
data modify storage mot_lamp:io input set from storage mot_lamp:class test
function mot_lamp:_new
tag @e[tag=result,limit=1] add test_device
data modify storage mot_uav:io input set from storage mot_uav:class test
function mot_uav:_new

execute as @e[tag=result,limit=1] run function marker_control:data/_get

# 控制程序管线
data modify storage marker_control:io result.lst_programs set value []
# 上升1格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"up"}]
data modify storage marker_control:io result.lst_programs[-1].delta_y set value 1.0d
# 降落近地面
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"near_landing"}]
# 连接设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"down_connect"}]
# 上升3格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"up"}]
data modify storage marker_control:io result.lst_programs[-1].delta_y set value 3.0d
# 打开设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"down_use"}]
# 前进5格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"forward"}]
data modify storage marker_control:io result.lst_programs[-1].w set value 5.0d
data remove storage marker_control:io result.lst_programs[-1].target_y
# 关闭设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"down_use"}]
# 降落近地面
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"near_landing"}]
# 断开设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"down_deconnect"}]
# 右偏0.5格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"forward"}]
data modify storage marker_control:io result.lst_programs[-1].u set value -0.5d
data remove storage marker_control:io result.lst_programs[-1].target_y
# 连接设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"left_connect"}]
# 等待1秒
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"waiting"}]
data modify storage marker_control:io result.lst_programs[-1].wait_time set value 20
# 打开设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"left_use"}]
# 等待1秒
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"waiting"}]
data modify storage marker_control:io result.lst_programs[-1].wait_time set value 20
# 关闭设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"left_use"}]
# 等待1秒
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"waiting"}]
data modify storage marker_control:io result.lst_programs[-1].wait_time set value 20
# 断开设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"left_deconnect"}]
# 左偏1格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"forward"}]
data modify storage marker_control:io result.lst_programs[-1].u set value 1.0d
data remove storage marker_control:io result.lst_programs[-1].target_y
# 连接设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"right_connect"}]
# 等待1秒
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"waiting"}]
data modify storage marker_control:io result.lst_programs[-1].wait_time set value 20
# 打开设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"right_use"}]
# 等待1秒
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"waiting"}]
data modify storage marker_control:io result.lst_programs[-1].wait_time set value 20
# 关闭设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"right_use"}]
# 等待1秒
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"waiting"}]
data modify storage marker_control:io result.lst_programs[-1].wait_time set value 20
# 断开设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"right_deconnect"}]
# 等待1秒
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"waiting"}]
data modify storage marker_control:io result.lst_programs[-1].wait_time set value 20
# 结束测试
data modify storage marker_control:io result.lst_programs append value {}

# 设置测试程序主函数和销毁函数
data modify storage marker_control:io result.tick_func set value "mot_uav:test/program/main"
data modify storage marker_control:io result.del_func set value "mot_uav:test/device_sync/end"

execute as @e[tag=result,limit=1] run function marker_control:data/_store
tag @e[tag=result,limit=1] add entity_ticked
tag @e[tag=result,limit=1] add entity_todel

# 设置测试程序运行时间
scoreboard players set @e[tag=result,limit=1] killtime 500

scoreboard players set n int 1