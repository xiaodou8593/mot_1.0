#mot_scenes:exhibition/main
# mot_scenes:exhibition/start异步调用

function marker_control:data/_get
data modify storage mot_scenes:io temp_state set from storage marker_control:io result.state
# 手动结束项目
execute if score test int matches 1 run return fail
# 结束状态提前返回
execute if data storage mot_scenes:io {temp_state:"end"} run return fail
# 刷新存在时间
scoreboard players set @s killtime 10

# 状态分支
execute if data storage mot_scenes:io {temp_state:"deconnecting"} run function mot_scenes:exhibition/deconnecting/main
execute if data storage mot_scenes:io {temp_state:"connecting"} run function mot_scenes:exhibition/connecting/main
execute if data storage mot_scenes:io {temp_state:"waiting"} run function mot_scenes:exhibition/waiting/main
execute if data storage mot_scenes:io {temp_state:"initing"} run function mot_scenes:exhibition/initing/main
execute if data storage mot_scenes:io {temp_state:"moving"} run function mot_scenes:exhibition/moving/main
execute if data storage mot_scenes:io {temp_state:"using"} run function mot_scenes:exhibition/using/main

function marker_control:data/_store