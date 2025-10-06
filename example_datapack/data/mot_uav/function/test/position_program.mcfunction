#mot_uav:test/position_program

function mot_uav:_get
data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"position"}]
data modify storage mot_uav:io program.target_y set value -50.0d
data modify storage mot_uav:io program.target_pos set value [8.0d,-50.0d,16.0d]
function mot_uav:_store