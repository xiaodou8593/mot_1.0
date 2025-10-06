#module_control:data/_reg
# 注册模块信息
# 输入storage module_control:io input
# 输出编号<res,int>

# 检查是否已经注册该路径
execute store result score res int run function module_control:data/check_dict with storage module_control:io input

# 如果已经注册路径
execute if score res int matches 1 run return run function module_control:data/replace_info

# 如果未注册路径
execute unless data storage module_control:io free_addr[0] run function module_control:new_addr
execute store result storage module_control:io index int 1 \
	store result score res int \
	run data get storage module_control:io free_addr[0]
data remove storage module_control:io free_addr[0]

function module_control:data/set_dict with storage module_control:io input
function module_control:data/replace_index with storage module_control:io {}