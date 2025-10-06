#module_control:data/replace_info
# module_control:data/_reg调用

# 获取路径的编号
execute store result storage module_control:io index int 1 \
	store result score res int \
	run function module_control:data/get_dict with storage module_control:io input

# 替换模块信息
function module_control:data/replace_index with storage module_control:io {}