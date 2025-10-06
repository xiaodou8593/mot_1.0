#mot_scatter:test/display/main

# test置1结束测试
execute if score test int matches 1 run return fail

# 刷新存在时间
scoreboard players set @s killtime 10

# test置-1刷新实例
execute unless score test int matches -1 run return fail
scoreboard players set test int 0
function mot_scatter:_del
function mot_scatter:test/display/start