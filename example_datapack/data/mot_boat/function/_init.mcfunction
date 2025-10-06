#mot_boat:_init
# 初始化mot_boat包

# 调用tick函数
kill @e[tag=mot_boat_tick]
summon marker 0 0 0 {Tags:["mot_boat_tick"],CustomName:'"mot_boat_tick"'}
execute as @e[tag=mot_boat_tick,limit=1] run function marker_control:data/_get
data modify storage marker_control:io result.tick_func set value "mot_boat:tick"
execute as @e[tag=mot_boat_tick,limit=1] run function marker_control:data/_store
tag @e[tag=mot_boat_tick,limit=1] add entity_ticked

# 初始化模块控制
scoreboard objectives add int dummy
execute unless score module_control_inited int matches 1 run function module_control:_init

# 注册本模块
data modify storage module_control:io input set value {prefix:"mot_boat:",namespace:"mot_boat"}
function module_control:data/_reg
scoreboard players operation #mot_boat: module_id = res int

# 建立记分板
scoreboard objectives add mot_uav_root dummy

# 设置常量
function mot_boat:_consts

# 生成静态数据模板
function mot_boat:_class