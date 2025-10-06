#mot_mover:_init
# 初始化mot_mover包

# 初始化模块控制
scoreboard objectives add int dummy
execute unless score module_control_inited int matches 1 run function module_control:_init

# 注册本模块
data modify storage module_control:io input set value {prefix:"mot_mover:",namespace:"mot_mover"}
function module_control:data/_reg
scoreboard players operation #mot_mover: module_id = res int

# 建立记分板
scoreboard objectives add mot_uav_root dummy

# 设置常量
function mot_mover:_consts

# 生成静态数据模板
function mot_mover:_class