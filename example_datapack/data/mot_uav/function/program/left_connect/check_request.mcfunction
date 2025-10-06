#mot_uav:program/left_connect/check_request
# mot_uav:program/left_connect/_run调用

execute if score res int matches 1.. run return fail
function module_control:_call_method {path:"_sync_request"}