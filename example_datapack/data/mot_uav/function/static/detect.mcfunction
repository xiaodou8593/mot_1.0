#mot_uav:static/detect
# mot_uav:main调用

# 永久静止状态直接返回1
execute if score motion_static int matches -1 run return 1

# 获取底盘位置
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get x int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get z int
scoreboard players operation sstempy int = y int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players operation sstempy int -= mot_uav_ch int

# 检测是否陷进方块里面
data modify entity @s Pos set from storage math:io xyz
execute at @s if block ~ ~ ~ #mot_uav:pass run scoreboard players set motion_static int 0
# 区块安全
tp @s 0 0 0

# 如果静止状态被打破则返回0
execute if score motion_static int matches 0 run return 0

# 保持静止状态则返回1
return 1