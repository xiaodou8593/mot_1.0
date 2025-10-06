#mot_boat:test/display/main

# test置1结束测试
execute if score test int matches 1 run return fail

# 刷新存在时间
scoreboard players set @s killtime 10

# test置-1刷新实例
execute unless score test int matches -1 run return fail
scoreboard players set test int 0
execute as @e[tag=mot_boat,tag=test,limit=1] run function mot_boat:_del
data modify storage mot_boat:io input set from storage mot_boat:class test
execute positioned 8 -59 8 run function mot_boat:_new
tag @e[tag=result,limit=1] add test