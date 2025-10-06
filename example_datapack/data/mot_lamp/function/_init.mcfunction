#mot_lamp:_init
# 初始化mot_lamp包

# 初始化模块控制
scoreboard objectives add int dummy
execute unless score module_control_inited int matches 1 run function module_control:_init

# 注册本模块
data modify storage module_control:io input set value {prefix:"mot_lamp:",namespace:"mot_lamp"}
function module_control:data/_reg
scoreboard players operation #mot_lamp: module_id = res int

# 添加记分板
scoreboard objectives add mot_uav_root dummy

# 设置常量
function mot_lamp:_consts

# 设置静态模板
function mot_lamp:_class