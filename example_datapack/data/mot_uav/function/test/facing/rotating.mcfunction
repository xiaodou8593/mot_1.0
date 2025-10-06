#mot_uav:test/facing/rotating
# mot_uav:test/facing/main调用

tag @e[tag=result] remove result
data modify entity @e[tag=uuid_marker,limit=1] Thrower set from storage marker_control:io result.enemy_uuid
execute as @e[tag=uuid_marker,limit=1] on origin run tag @s add result
execute unless entity @e[tag=result,limit=1] run return run data modify storage marker_control:io result.state set value "get_enemy"

execute if data storage mot_uav:io program{state:2} run return run function mot_uav:test/facing/s_attacking

execute as @e[tag=result] at @s anchored eyes run tp @e[tag=math_marker,limit=1] ^ ^-0.5 ^
execute store result score target_y int run data get storage mot_uav:io program.target_y 10000
data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"facing"}]
data modify storage math:io xyz set from entity @e[tag=math_marker,limit=1] Pos
execute store result score vec_x int run data get storage math:io xyz[0] 10000
execute store result score vec_y int run data get storage math:io xyz[1] 10000
execute store result score vec_z int run data get storage math:io xyz[2] 10000
scoreboard players operation vec_x int -= x int
scoreboard players operation vec_y int -= y int
scoreboard players operation vec_z int -= z int
scoreboard players set u int 6250
scoreboard players set v int 1000
scoreboard players set w int 11250
execute as @e[tag=math_marker,limit=1] run function math:rot/_local_facing
execute as @e[tag=math_marker,limit=1] run function math:rot/_tovec
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players operation vec_x int += x int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players operation vec_y int += y int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players operation vec_z int += z int
data modify storage mot_uav:io program.facing_pos set from storage math:io xyz
execute store result storage mot_uav:io program.target_y double 0.0001 run scoreboard players get target_y int