#mot_uav:test/rotation_program

function mot_uav:_get
data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"rotation"}]
data modify storage mot_uav:io program.target_y set value -50.0d
data modify storage mot_uav:io program.target_theta set value 90.0f
function mot_uav:_store