#module_control:data/_del
# 删除模块信息
# 输入编号<inp,int>
# 输出模块信息storage module_control:io result

# 弹出模块信息
execute store result storage module_control:io index int 1 run scoreboard players get inp int
function module_control:data/get_index with storage module_control:io {}

# 删除路径
function module_control:data/rmv_dict with storage module_control:io result

# 释放编号
data modify storage module_control:io free_addr prepend from storage module_control:io index