#module_control:test/module_a/_init
# 初始化module_a

# 初始化模块控制
scoreboard objectives add int dummy
execute unless score module_control_inited int matches 1 run function module_control:_init

# 注册本模块
data modify storage module_control:io input set value {prefix:"module_control:test/module_a/",namespace:"module_control"}
function module_control:data/_reg
scoreboard players operation #module_control:test/module_a/ module_id = res int