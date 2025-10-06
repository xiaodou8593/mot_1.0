#mot_uav:test/facing/s_attacking
# mot_uav:test/facing/rotating调用

data modify storage marker_control:io result.attack_cnt set value 20
data modify storage marker_control:io result.state set value "attacking"
data modify storage marker_control:io result.facing_program set from storage mot_uav:io program