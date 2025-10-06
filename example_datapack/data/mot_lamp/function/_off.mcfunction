#mot_lamp:_off
# 关闭红石灯
# 以设备实例为执行者

execute on passengers run data remove entity @s brightness
execute on passengers run data modify entity @s block_state.Properties.lit set value "false"

execute at @s run playsound minecraft:block.lever.click player @a ~ ~ ~ 0.5 0.5