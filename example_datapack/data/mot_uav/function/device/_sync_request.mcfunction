#mot_uav:device/_sync_request
# 输入请求设备编号<inp,int>
# 输入插槽类型storage mot_uav:io slot_type
# 以外接设备实例为执行者
# 输出<res,int>，同意连接?设备编号:0

# 没有连接设备则同意请求
execute if score @s mot_uav_root matches 0 run return run function mot_uav:device/agree_request

# 连接到无人机设备则拒接请求
scoreboard players operation tempid int = @s mot_uav_root
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run return run scoreboard players set res int 0

# 连接到非无人机设备则同意请求
function mot_uav:device/agree_request