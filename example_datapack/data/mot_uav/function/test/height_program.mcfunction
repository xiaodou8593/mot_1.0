#mot_uav:test/height_program
# 聊天栏调用
# 需要以无人机为执行者

function mot_uav:_get
data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"height"}]
data modify storage mot_uav:io program.target_y set value -50.0d
function mot_uav:_store