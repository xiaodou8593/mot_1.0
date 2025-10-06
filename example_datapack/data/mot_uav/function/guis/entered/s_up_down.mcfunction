#mot_uav:guis/entered/s_up_down

data modify storage iframe:io temp set value "up"
execute if data storage iframe:io result{button_0:"up"} run data modify storage iframe:io temp set value "down"
data modify storage iframe:io result.button_0 set from storage iframe:io temp

function iframe:player_space/_store
scoreboard players set update_gui int 1