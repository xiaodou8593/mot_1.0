#mot_uav:program/down_use/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 提前返回
execute if score state int matches 2 run return fail

# 设备使用中，则程序继续运行
scoreboard players set state int 1

# 向设备发送使用信号
scoreboard players set res int 1
execute as @e[tag=mot_device] if score @s mot_uav_id = down_slot_id int \
	run function module_control:_call_method {path:"_use_signal"}

# 设备是否使用结束
execute if score res int matches 1 run scoreboard players set state int 2