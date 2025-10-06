#mot_scatter:bullet/set
# mot_scatter:bullet/_new调用

# 使用实例的NBT来储存数据，而不是通常的记分板
data modify entity @s Pos set from storage mot_scatter:io input.kvec
execute positioned 0.0 0.0 0.0 facing entity @s feet run tp @s ~ ~ ~ ~ ~
data modify entity @s Pos set from storage mot_scatter:io input.position

execute store result score @s killtime run data get storage mot_scatter:io input.killtime