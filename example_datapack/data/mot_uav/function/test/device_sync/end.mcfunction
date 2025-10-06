#mot_uav:test/device_sync/end

execute as @e[tag=test_device] run function module_control:_call_method {path:"_del"}
function mot_uav:_del