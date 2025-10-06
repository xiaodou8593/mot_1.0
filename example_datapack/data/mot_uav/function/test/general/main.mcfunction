#mot_uav:test/general/main

# test信号为1结束测试
execute if score test int matches 1 run return fail

# 刷新存在时间
scoreboard players set @s killtime 10