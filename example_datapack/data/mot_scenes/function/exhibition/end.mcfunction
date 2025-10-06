#mot_scenes:exhibition/end
# mot_scenes:exhibition/start异步调用

# 销毁所有设备
execute as @e[tag=mot_device,tag=test] run function module_control:_call_method {path:"_del"}