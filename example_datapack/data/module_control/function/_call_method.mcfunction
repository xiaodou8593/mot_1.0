#module_control:_call_method
# 调用模块实例的方法
# 以模块实例为执行者
# 输入macro {path:""}
# 输出storage module_control:io result

# 弹出模块信息
execute store result storage module_control:io index int 1 run scoreboard players get @s module_id
function module_control:data/get_index with storage module_control:io {}

$data modify storage module_control:io result.path set value "$(path)"
function module_control:run_func with storage module_control:io result