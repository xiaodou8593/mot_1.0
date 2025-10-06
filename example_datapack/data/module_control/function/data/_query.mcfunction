#module_control:data/_query
# 查询模块信息
# 输入编号<inp,int>
# 输出模块信息storage module_control:io result

# 弹出模块信息
execute store result storage module_control:io index int 1 run scoreboard players get inp int
function module_control:data/get_index with storage module_control:io {}