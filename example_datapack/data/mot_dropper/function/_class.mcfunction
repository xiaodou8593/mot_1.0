#mot_dropper:_class
# 生成预设静态数据模板

# 生成测试数据模板
function mot_dropper:_zero
execute positioned 8 -59 8 rotated 0.0 0.0 as @e[tag=math_marker,limit=1] run function mot_dropper:_anchor_to
function mot_dropper:_model
data modify storage mot_dropper:class test set from storage mot_dropper:io result