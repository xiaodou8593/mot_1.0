#mot_lamp:_on
# 打开红石灯
# 以设备实例为执行者

execute on passengers run data modify entity @s brightness set value {sky:15, block:15}
execute on passengers run data modify entity @s block_state.Properties.lit set value "true"

execute at @s run playsound minecraft:block.lever.click player @a ~ ~ ~ 0.5 0.5