#module_control:data/_print
# 输出模块数据结构调试信息

tellraw @a "module_data: {"
tellraw @a ["    prefix_dict: ",{"nbt":"prefix_dict","storage":"module_control:io"}]
tellraw @a ["    list_infos: ",{"nbt":"list_infos","storage":"module_control:io"}]
tellraw @a "}"