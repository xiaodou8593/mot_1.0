#module_control:new_addr
# module_control:data/_reg调用

data modify storage module_control:io free_addr prepend value 0
execute store result storage module_control:io free_addr[0] int 1 run scoreboard players add #id module_id 1

data modify storage module_control:io list_infos append value {}