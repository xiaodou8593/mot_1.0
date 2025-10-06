#mot_scatter:_init
# 初始化mot_scatter包

# 初始化模块控制
scoreboard objectives add int dummy
execute unless score module_control_inited int matches 1 run function module_control:_init

# 注册本模块
data modify storage module_control:io input set value {prefix:"mot_scatter:",namespace:"mot_scatter"}
function module_control:data/_reg
scoreboard players operation #mot_scatter: module_id = res int

# 建立记分板
scoreboard objectives add scatter_phi dummy
scoreboard objectives add bullet_res dummy
scoreboard objectives add mot_uav_root dummy

# 设置常量
function mot_scatter:_consts

# 生成静态数据模板
function mot_scatter:_class

# 初始化子模块
function mot_scatter:bullet/init