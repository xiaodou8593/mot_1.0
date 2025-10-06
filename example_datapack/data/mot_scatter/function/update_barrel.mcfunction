#mot_scatter:update_barrel
# mot_scatter:set_operations调用
# mot_scatter:main调用

scoreboard players operation temp_phi int = @s scatter_phi
execute on passengers run function mot_scatter:update_barrel_phi