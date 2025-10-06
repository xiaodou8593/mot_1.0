#mot_scenes:exhibition/moving/append_rotation
# mot_scenes:exhibition/moving/enter调用

data modify storage mot_uav:io program.list_programs append from storage mot_scenes:class default_programs[{id:"rotation"}]
data modify storage mot_uav:io program.list_programs[-1].target_theta set from storage mot_scenes:io input.target_theta