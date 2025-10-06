#mot_scenes:program/init

# 预设控制程序的数据模板
data modify storage mot_scenes:class default_programs set value [\
	{id:"waiting", pointer:"mot_scenes:program/waiting", state:0, wait_time:-1},\
	{id:"rotation", pointer:"mot_scenes:program/rotation", target_y:0.0d, target_theta:0.0d, damp_params:[0.0095d,0.01d,0.08d], state:0},\
	{id:"position", pointer:"mot_scenes:program/position", target_y:0.0d, target_pos:[0.0d,0.0d,0.0d], damp_params:[0.95d,1.0d,0.008d], state:0},\
	{id:"turn", pointer:"mot_scenes:program/turn", delta_theta:0.0d, target_y:0.0d, target_theta:0.0d, damp_params:[0.0095d,0.01d,0.08d], state:0},\
	{id:"forward", pointer:"mot_scenes:program/forward", u:0.0d, v:0.0d, w:0.0d, target_y:0.0d, target_pos:[0.0d,0.0d,0.0d], damp_params:[0.95d,1.0d,0.008d], state:0},\
	{id:"facing", pointer:"mot_scenes:program/facing", target_y:0.0d, facing_pos:[0.0d,0.0d,0.0d], damp_params:[0.0095d,0.01d,0.08d], state:0}\
]