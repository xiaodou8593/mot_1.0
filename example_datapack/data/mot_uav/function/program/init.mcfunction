#mot_uav:program/init
# mot_uav:_init调用

scoreboard players set -3333 int -3333
scoreboard players set 3333 int 3333

# 预设控制程序的数据模板
data modify storage mot_uav:class default_programs set value [\
	{id:"compose", pointer:"mot_uav:program/compose", state:0, list_programs:[]},\
	{id:"waiting", pointer:"mot_uav:program/waiting", state:0, wait_time:-1},\
	{id:"landing", pointer:"mot_uav:program/landing", state:0},\
	{id:"near_landing", pointer:"mot_uav:program/near_landing", state:0},\
	{id:"left_connect", pointer:"mot_uav:program/left_connect", state:0},\
	{id:"left_deconnect", pointer:"mot_uav:program/left_deconnect", state:0},\
	{id:"left_use", pointer:"mot_uav:program/left_use", state:0},\
	{id:"down_connect", pointer:"mot_uav:program/down_connect", state:0},\
	{id:"down_deconnect", pointer:"mot_uav:program/down_deconnect", state:0},\
	{id:"down_use", pointer:"mot_uav:program/down_use", state:0},\
	{id:"right_connect", pointer:"mot_uav:program/right_connect", state:0},\
	{id:"right_deconnect", pointer:"mot_uav:program/right_deconnect", state:0},\
	{id:"right_use", pointer:"mot_uav:program/right_use", state:0},\
	{id:"height", pointer:"mot_uav:program/height", target_y:0.0d, damp_params:[0.95d,1.0d,0.008d], state:0},\
	{id:"rotation", pointer:"mot_uav:program/rotation", target_y:0.0d, target_theta:0.0d, damp_params:[0.0095d,0.01d,0.08d], state:0},\
	{id:"position", pointer:"mot_uav:program/position", target_y:0.0d, target_pos:[0.0d,0.0d,0.0d], damp_params:[0.95d,1.0d,0.008d], state:0},\
	{id:"up", pointer:"mot_uav:program/up", delta_y:0.0d, target_y:0.0d, damp_params:[0.95d,1.0d,0.008d], state:0},\
	{id:"turn", pointer:"mot_uav:program/turn", delta_theta:0.0d, target_y:0.0d, target_theta:0.0d, damp_params:[0.0095d,0.01d,0.08d], state:0},\
	{id:"forward", pointer:"mot_uav:program/forward", u:0.0d, v:0.0d, w:0.0d, target_y:0.0d, target_pos:[0.0d,0.0d,0.0d], damp_params:[0.95d,1.0d,0.008d], state:0},\
	{id:"facing", pointer:"mot_uav:program/facing", target_y:0.0d, facing_pos:[0.0d,0.0d,0.0d], damp_params:[0.0095d,0.01d,0.08d], state:0}\
]