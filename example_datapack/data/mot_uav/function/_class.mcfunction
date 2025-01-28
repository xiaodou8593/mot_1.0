#mot_uav:_class
# 生成预设静态数据模板

# 生成测试数据模板
function mot_uav:_zero
execute positioned 8 -56 8 rotated 0.0 0.0 as @e[tag=math_marker,limit=1] run function mot_uav:_anchor_to
function mot_uav:_model
data modify storage mot_uav:class test set from storage mot_uav:io result