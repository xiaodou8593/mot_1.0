#mot_lamp:_class
# 生成预设静态数据模板

# 生成测试数据模板
function mot_lamp:_zero
execute positioned 8 -59 8 rotated 0.0 0.0 as @e[tag=math_marker,limit=1] run function mot_lamp:_anchor_to
function mot_lamp:_model
data modify storage mot_lamp:class test set from storage mot_lamp:io result