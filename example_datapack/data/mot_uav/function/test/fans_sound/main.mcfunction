#mot_uav:test/fans_sound/main

# 过滤时间
scoreboard players operation res int = @s killtime
scoreboard players operation res int %= test int
execute unless score res int matches 0 run return fail

# 播放测试音效
execute as @a at @s run playsound minecraft:entity.ender_dragon.flap player @s ~ ~ ~ 1.0 2.0