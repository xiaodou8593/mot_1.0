#mot_uav:test/display/main

# 维持项目运行时间
scoreboard players set @s killtime 20

# 信号检测
execute if score test int matches 0 run return fail
scoreboard players set test int 0

# 销毁之前的测试实例
execute as @e[tag=test,tag=mot_uav] run function mot_uav:_del
# 生成新的测试实例
data modify storage mot_uav:io input set from storage mot_uav:class test
data modify entity @e[tag=math_marker,limit=1] Pos set from storage mot_uav:io input.position
execute at @e[tag=math_marker,limit=1] run function mot_uav:_new
tag @e[tag=result,limit=1] add test