#mot_uav:_new_id
# 分配编号
# 输出<res,int>

execute unless data storage mot_uav:io free_addr[0] run function mot_uav:new_addr
execute store result score res int run data get storage mot_uav:io free_addr[0]
data remove storage mot_uav:io free_addr[0]