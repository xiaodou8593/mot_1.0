#mot_uav:guis/entered/enter

function iframe:player_space/_get

execute store result score @s mot_uav_using run data get storage iframe:io result.mot_uav_id

data modify storage iframe:io result.button_0 set value "up"
data modify storage iframe:io result.button_1 set value "counterclockwise"

function iframe:player_space/_store

function mot_uav:guis/entered/items