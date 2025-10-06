#mot_uav:program/left_connect/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 提前返回
execute if score state int matches 2 run return fail

# 连接输入
scoreboard players operation inp int = tempid int
data modify storage mot_uav:io slot_type set value "left"

# 计算插槽坐标，向附近设备发送请求
scoreboard players set u int 2500
scoreboard players set v int 0
scoreboard players set w int 0
function math:uvw/_topos
scoreboard players set res int 0
execute at @s as @e[tag=mot_device,distance=..1] run function mot_uav:program/left_connect/check_request
scoreboard players operation inp int = res int

# 连接程序结束
scoreboard players set state int 2
execute if score inp int matches 0 run scoreboard players set state int -1

# 确认连接
execute if score inp int matches 0 run return run tp @s 0 0 0
execute at @s run playsound minecraft:block.piston.contract player @a ~ ~ ~ 0.5 2.0
function mot_uav:left_slot/_connect

# 区块安全
tp @s 0 0 0