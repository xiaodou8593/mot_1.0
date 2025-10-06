#mot_uav:fans/_on
# 打开机翼电机
# 以mot_uav实例为执行者

scoreboard players set @s fans_power 1
# 关闭静体优化
scoreboard players set @s motion_static 0
function mot_uav:fans/update_torch

execute at @s run playsound minecraft:block.note_block.banjo player @a ~ ~0.6 ~ 0.5 2.0