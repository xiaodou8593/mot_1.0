#mot_uav:fans/_off
# 打开机翼电机
# 以mot_uav实例为执行者

scoreboard players set @s fans_power 0
function mot_uav:fans/update_torch

execute at @s run playsound minecraft:block.redstone_torch.burnout player @a ~ ~0.6 ~ 0.5 2.0