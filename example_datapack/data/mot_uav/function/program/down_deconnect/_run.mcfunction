#mot_uav:program/down_deconnect/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 提前返回
execute if score state int matches 2 run return fail

# 断开连接
function mot_uav:down_slot/_deconnect

# 播放音效
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get impulse_x int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players get impulse_y int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get impulse_z int
data modify entity @s Pos set from storage math:io xyz
execute at @s run playsound minecraft:block.piston.extend player @a ~ ~ ~ 0.5 2.0

# 区块安全
tp @s 0 0 0

# 连接程序结束
scoreboard players set state int 2