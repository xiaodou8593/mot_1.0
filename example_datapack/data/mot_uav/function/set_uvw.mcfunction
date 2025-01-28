#mot_uav:set_uvw
# mot_uav:_new调用

data modify storage mot_uav:io translation set from entity @s transformation.translation
execute store result score @s u run data get storage mot_uav:io translation[0] 10000
execute store result score @s v run data get storage mot_uav:io translation[1] 10000
execute store result score @s w run data get storage mot_uav:io translation[2] 10000