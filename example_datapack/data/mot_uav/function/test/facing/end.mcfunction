#mot_uav:test/facing/end

execute as @e[tag=test_device] run function module_control:_call_method {path:"_del"}
function mot_uav:_del