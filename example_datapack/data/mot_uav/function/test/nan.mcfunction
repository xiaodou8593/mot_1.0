#mot_uav:test/nan

tellraw @a "--- mot_uav nan result ---"

tag @e[tag=result] remove result
summon item_display 0 0 0 {Tags:["result"]}

data modify entity @e[tag=result,limit=1] transformation.left_rotation set value [0.0f,0.0f,0.0f,0.0f]
tellraw @a ["lr: ", {"nbt":"transformation.left_rotation","entity":"@e[tag=result,limit=1]"}]

kill @e[tag=result,limit=1]