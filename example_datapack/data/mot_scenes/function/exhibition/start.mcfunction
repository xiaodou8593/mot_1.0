#mot_scenes:exhibition/start
# 聊天栏调用

tag @e[tag=test] remove test

# 初始化控制程序模板
function mot_scenes:program/init

# 状态列表
data modify storage mot_scenes:io list_states set value [\
	{state:"moving", target_pos:[20.5d,-58.5d,-5.0d],target_theta:-90.0f},\
	{state:"moving", target_pos:[20.5d,-59.5d,-5.0d],target_theta:-90.0f},\
	{state:"connecting", slot:"right"},\
	{state:"waiting", wait_time:20},\
	{state:"using", use_cnt:1, slot:"right"},\
	{state:"waiting", wait_time:40},\
	{state:"moving", target_pos:[20.5d,-59.5d,-3.5d],target_theta:-90.0f},\
	{state:"connecting", slot:"left"},\
	{state:"waiting", wait_time:20},\
	{state:"using", use_cnt:20, slot:"left"},\
	{state:"moving", target_pos:[20.5d,-56.5d,-3.5d],target_theta:-45.0f},\
	{state:"using", use_cnt:20, slot:"left"},\
	{state:"moving", target_pos:[20.5d,-56.5d,-3.5d],target_theta:-67.5f},\
	{state:"using", use_cnt:40, slot:"left"},\
	{state:"moving", target_pos:[20.5d,-59.0d,-3.5d],target_theta:-45.0f},\
	{state:"using", use_cnt:1, slot:"right"},\
	{state:"deconnecting", slot:"right"},\
	{state:"waiting", wait_time:20},\
	{state:"moving", target_pos:[20.5d,-58.5d,1.0d],target_theta:-90.0f},\
	{state:"moving", target_pos:[20.5d,-59.5d,1.0d],target_theta:-90.0f},\
	{state:"connecting", slot:"right"},\
	{state:"waiting", wait_time:20},\
	{state:"using", use_cnt:1, slot:"right"},\
	{state:"moving", target_pos:[20.5d,-56.5d,1.0d],target_theta:-45.0f},\
	{state:"using", use_cnt:20, slot:"left"},\
	{state:"using", use_cnt:1, slot:"right"},\
	{state:"moving", target_pos:[20.5d,-56.5d,1.0d],target_theta:-22.5f},\
	{state:"using", use_cnt:1, slot:"right"},\
	{state:"waiting", wait_time:20},\
	{state:"using", use_cnt:1, slot:"right"},\
	{state:"waiting", wait_time:20},\
	{state:"using", use_cnt:1, slot:"right"},\
	{state:"waiting", wait_time:10},\
	{state:"moving", target_pos:[20.5d,-58.5d,3.5d],target_theta:-90.0f},\
	{state:"moving", target_pos:[20.5d,-59.5d,3.5d],target_theta:-90.0f},\
	{state:"connecting", slot:"down"},\
	{state:"waiting", wait_time:20},\
	{state:"moving", target_pos:[17.5d,-58.5d,3.5d],target_theta:-90.0f},\
	{state:"using", use_cnt:1, slot:"down"},\
	{state:"moving", target_pos:[14.5d,-57.5d,3.5d],target_theta:-90.0f},\
	{state:"moving", target_pos:[14.5d,-58.5d,3.5d],target_theta:-90.0f},\
	{state:"using", use_cnt:1, slot:"down"},\
	{state:"moving", target_pos:[14.5d,-57.5d,3.5d],target_theta:-90.0f},\
	{state:"waiting", wait_time:40},\
	{state:"moving", target_pos:[14.5d,-58.5d,3.5d],target_theta:-90.0f},\
	{state:"using", use_cnt:1, slot:"down"},\
	{state:"moving", target_pos:[17.5d,-57.5d,3.5d],target_theta:-45.0f},\
	{state:"deconnecting", slot:"down"},\
	{state:"waiting", wait_time:20},\
	{state:"moving", target_pos:[20.5d,-58.5d,6.5d],target_theta:-90.0f},\
	{state:"moving", target_pos:[20.5d,-59.0d,6.5d],target_theta:-90.0f},\
	{state:"connecting", slot:"down"},\
	{state:"moving", target_pos:[20.5d,-50.0d,6.5d],target_theta:-90.0f},\
	{state:"moving", target_pos:[12.5d,-50.0d,6.5d],target_theta:-45.0f},\
	{state:"deconnecting", slot:"down"},\
	{state:"waiting", wait_time:20},\
	{state:"moving", target_pos:[20.5d,-58.5d,9.5d],target_theta:-90.0f},\
	{state:"moving", target_pos:[20.5d,-59.5d,9.5d],target_theta:-90.0f},\
	{state:"connecting", slot:"down"},\
	{state:"waiting", wait_time:20},\
	{state:"moving", target_pos:[17.5d,-58.5d,9.5d],target_theta:-90.0f},\
	{state:"using", use_cnt:1, slot:"down"},\
	{state:"moving", target_pos:[13.5d,-52.0d,16.5d],target_theta:-90.0f},\
	{state:"using", use_cnt:1, slot:"down"},\
	{state:"waiting", wait_time:80},\
	{state:"moving", target_pos:[20.5d,-58.5d,9.5d],target_theta:-90.0f},\
	{state:"deconnecting", slot:"left"},\
	{state:"waiting", wait_time:10},\
	{state:"deconnecting", slot:"down"},\
	{state:"waiting", wait_time:10},\
	{state:"deconnecting", slot:"right"},\
	{state:"waiting", wait_time:10},\
	{state:"waiting", wait_time:60}\
]

# 生成展览设备

# 测试红石灯
function mot_lamp:_zero
execute positioned 20 -58 -6 rotated 90.0 0.0 as @e[tag=math_marker,limit=1] run function mot_lamp:_anchor_to
function mot_lamp:_model
data modify storage mot_lamp:io input set from storage mot_lamp:io result
function mot_lamp:_new
tag @e[tag=result,limit=1] add test

# 机枪
function mot_scatter:_zero
execute positioned 20 -58 -3 rotated 90.0 0.0 as @e[tag=math_marker,limit=1] run function mot_scatter:_anchor_to
function mot_scatter:_model
data modify storage mot_scatter:io input set from storage mot_scatter:io result
function mot_scatter:_new
tag @e[tag=result,limit=1] add test

# 激光枪
function mot_laser:_zero
execute positioned 20 -58 0 rotated 90.0 0.0 as @e[tag=math_marker,limit=1] run function mot_laser:_anchor_to
function mot_laser:_model
data modify storage mot_laser:io input set from storage mot_laser:io result
function mot_laser:_new
tag @e[tag=result,limit=1] add test

# 方块搬运器
function mot_mover:_zero
execute positioned 20 -58 3 rotated 90.0 0.0 as @e[tag=math_marker,limit=1] run function mot_mover:_anchor_to
function mot_mover:_model
data modify storage mot_mover:io input set from storage mot_mover:io result
function mot_mover:_new
tag @e[tag=result,limit=1] add test

# 栓绳船
data modify storage mot_boat:io input set from storage mot_boat:class test
execute positioned 20 -58 6 run function mot_boat:_new
tag @e[tag=result,limit=1] add test

# 投弹器
function mot_dropper:_zero
execute positioned 20 -58 9 rotated 90.0 0.0 as @e[tag=math_marker,limit=1] run function mot_dropper:_anchor_to
function mot_dropper:_model
data modify storage mot_dropper:io input set from storage mot_dropper:io result
function mot_dropper:_new
tag @e[tag=result,limit=1] add test

# 生成无人机
function mot_uav:_zero
execute positioned 23 -58 -6 rotated 90.0 0.0 as @e[tag=math_marker,limit=1] run function mot_uav:_anchor_to
function mot_uav:_model
data modify storage mot_uav:io input set from storage mot_uav:io result
function mot_uav:_new
tag @e[tag=result,limit=1] add test

# 生成测试方块
setblock 17 -60 3 minecraft:chest[facing=west,type=single,waterlogged=false]{Items:[{Slot:0b,count:64,id:"minecraft:oak_log"},{Slot:1b,count:64,id:"minecraft:light_blue_concrete"}]}
setblock 17 -60 9 minecraft:tnt[unstable=false]
setblock 10 -59 17 minecraft:obsidian
setblock 10 -59 16 minecraft:obsidian
setblock 10 -59 15 minecraft:obsidian
setblock 11 -59 14 minecraft:obsidian
setblock 12 -59 13 minecraft:obsidian
setblock 13 -59 13 minecraft:obsidian
setblock 14 -59 13 minecraft:obsidian
setblock 15 -59 14 minecraft:obsidian
setblock 16 -59 15 minecraft:obsidian
setblock 16 -59 16 minecraft:obsidian
setblock 16 -59 17 minecraft:obsidian
setblock 15 -59 18 minecraft:obsidian
setblock 14 -59 19 minecraft:obsidian
setblock 13 -59 19 minecraft:obsidian
setblock 12 -59 19 minecraft:obsidian
setblock 11 -59 18 minecraft:obsidian
fill 11 -60 18 15 -60 14 minecraft:obsidian

# 生成测试实例
tag @e[tag=result] remove result
summon marker 0 0 0 {Tags:["mot_scene","test","result"],CustomName:'"mot_scene"'}
execute as @e[tag=result,limit=1] run function marker_control:data/_get
data modify storage marker_control:io result.tick_func set value "mot_scenes:exhibition/main"
data modify storage marker_control:io result.del_func set value "mot_scenes:exhibition/end"
execute as @e[tag=result,limit=1] run function mot_scenes:exhibition/initing/enter
execute as @e[tag=result,limit=1] run function marker_control:data/_store
tag @e[tag=result,limit=1] add entity_ticked
tag @e[tag=result,limit=1] add entity_todel
scoreboard players set @e[tag=result,limit=1] killtime 10
scoreboard players set test int 0