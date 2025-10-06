#mot_uav:fans/sound
# mot_uav:fans/main调用

scoreboard players set sstemp_mod int 5
execute if score fans_power int matches 125.. run scoreboard players set sstemp_mod int 3
scoreboard players operation sstemp int = fans_timer int
scoreboard players operation sstemp int %= sstemp_mod int
execute if score sstemp int matches 0 at @s run playsound minecraft:entity.ender_dragon.flap player @a ~ ~0.6 ~ 0.1 2.0