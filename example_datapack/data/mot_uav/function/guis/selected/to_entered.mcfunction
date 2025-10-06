#mot_uav:guis/selected/to_entered

execute at @s run playsound minecraft:block.note_block.bass player @s ~ ~ ~ 1.0 1.0

data modify storage iframe:io input set value "mot_uav:guis/entered"
function iframe:_enter