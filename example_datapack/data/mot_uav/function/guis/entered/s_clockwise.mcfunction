#mot_uav:guis/entered/s_clockwise

data modify storage iframe:io temp set value "clockwise"
execute if data storage iframe:io result{button_1:"clockwise"} run data modify storage iframe:io temp set value "counterclockwise"
data modify storage iframe:io result.button_1 set from storage iframe:io temp

function iframe:player_space/_store
scoreboard players set update_gui int 1