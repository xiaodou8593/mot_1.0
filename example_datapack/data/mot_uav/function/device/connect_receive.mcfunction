#mot_uav:device/connect_receive
# mot_uav:device/_main_sync调用

data modify storage mot_uav:io input set from storage mot_uav:io list_impulse
function mot_uav:impulse/_append_list
data modify storage mot_uav:io list_impulse set value []