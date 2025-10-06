#mot_lamp:_use_signal
# 接收使用信号
# 输出<res,int>, 使用结束?1:0

# 改变红石灯状态
execute on passengers run data modify storage mot_lamp:io lit set from entity @s block_state.Properties.lit
execute if data storage mot_lamp:io {lit:"true"} run function mot_lamp:_off
execute if data storage mot_lamp:io {lit:"false"} run function mot_lamp:_on

# 单次触发直接结束
scoreboard players set res int 1