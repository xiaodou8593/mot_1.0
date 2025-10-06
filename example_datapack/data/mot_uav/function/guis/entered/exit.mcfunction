#mot_uav:guis/entered/exit

function iframe:_exit_inv

scoreboard players reset @s mot_uav_using

execute at @s run playsound minecraft:block.note_block.bass player @s ~ ~ ~ 1.0 1.0