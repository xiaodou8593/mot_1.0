#mot_uav:test/facing/end_s0
# mot_uav:test/facing/main调用

function marker_control:data/_get

data remove storage marker_control:io result.tick_funcs[-1]
tag @s add mot_uav_facing_test
data modify storage marker_control:io result.state set value "get_enemy"

function marker_control:data/_store

scoreboard players set @s killtime 500