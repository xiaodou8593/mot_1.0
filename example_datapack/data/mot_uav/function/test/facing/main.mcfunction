#mot_uav:test/facing/main

function mot_uav:_get

execute unless entity @s[tag=mot_uav_facing_test] if data storage mot_uav:io program{pointer:"mot_uav:program/waiting"} run function mot_uav:test/facing/end_s0
execute unless entity @s[tag=mot_uav_facing_test] run return fail

function marker_control:data/_get
data modify storage mot_uav:io temp_state set from storage marker_control:io result.state
execute if data storage mot_uav:io {temp_state:"get_enemy"} run function mot_uav:test/facing/get_enemy
execute if data storage mot_uav:io {temp_state:"rotating"} run function mot_uav:test/facing/rotating
execute if data storage mot_uav:io {temp_state:"attacking"} run function mot_uav:test/facing/attacking
function marker_control:data/_store
function mot_uav:_store