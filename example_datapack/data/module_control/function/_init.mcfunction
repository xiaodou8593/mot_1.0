#module_control:_init
# 初始化模块控制

# 储存模块信息的数据结构
data modify storage module_control:io prefix_dict set value {}
data modify storage module_control:io list_infos set value []

# 建立编号池
data modify storage module_control:io free_addr set value []

scoreboard objectives add module_id dummy
# 编号从0开始以便访问列表下标
scoreboard players set #id module_id -1

# 外部访问初始化状态
scoreboard objectives add int dummy
scoreboard players set module_control_inited int 1