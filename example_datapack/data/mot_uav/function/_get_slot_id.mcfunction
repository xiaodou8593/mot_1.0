#mot_uav:_get_slot_id
# 返回槽位连接编号
# 以无人机实例为执行者
# 输入storage mot_uav:io slot_type
# 输出<res,int>

execute if data storage mot_uav:io {slot_type:"left"} run scoreboard players operation res int = @s left_slot_id
execute if data storage mot_uav:io {slot_type:"down"} run scoreboard players operation res int = @s down_slot_id
execute if data storage mot_uav:io {slot_type:"right"} run scoreboard players operation res int = @s right_slot_id