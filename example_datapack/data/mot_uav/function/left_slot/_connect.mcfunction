#mot_uav:left_slot/_connect
# 输入mot_uav临时对象
# 输入设备编号<inp,int>

# 完成单方向连接
scoreboard players operation left_slot_id int = inp int

# 关闭静体优化
scoreboard players set motion_static int 0