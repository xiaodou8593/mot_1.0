#mot_uav:_class
# 生成预设静态数据模板

# 生成测试数据模板
function mot_uav:_zero
execute positioned 8 -56 8 rotated 0.0 0.0 as @e[tag=math_marker,limit=1] run function mot_uav:_anchor_to
function mot_uav:_model
data modify storage mot_uav:class test set from storage mot_uav:io result

# 无人机计数器
scoreboard objectives add mot_uav_id dummy
scoreboard players set #id mot_uav_id 0

# 编号池
data modify storage mot_uav:io free_addr set value []

# 初始化模块控制
scoreboard objectives add int dummy
execute unless score module_control_inited int matches 1 run function module_control:_init

# 注册本模块
data modify storage module_control:io input set value {prefix:"mot_uav:",namespace:"mot_uav"}
function module_control:data/_reg
scoreboard players operation #mot_uav: module_id = res int