#mot_laser:_init
# 初始化mot_laser包

# 初始化模块控制
scoreboard objectives add int dummy
execute unless score module_control_inited int matches 1 run function module_control:_init

# 注册本模块
data modify storage module_control:io input set value {prefix:"mot_laser:",namespace:"mot_laser"}
function module_control:data/_reg
scoreboard players operation #mot_laser: module_id = res int

# 建立记分板
scoreboard objectives add bullet_res dummy
scoreboard objectives add mot_uav_root dummy

# 设置常量
function mot_laser:_consts

# 生成静态数据模板
function mot_laser:_class

# 初始化子模块
function mot_laser:bullet/init