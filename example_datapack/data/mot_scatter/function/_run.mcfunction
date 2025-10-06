#mot_scatter:_run
# 运行机枪

# 转动枪管
scoreboard players add scatter_phi int 60000
scoreboard players operation scatter_phi int %= 3600000 int
scoreboard players operation temp_phi int = scatter_phi int
execute on passengers run function mot_scatter:update_barrel_phi

# 关闭静体优化
scoreboard players set motion_static int 0

tag @s remove triggered

# 无剩余子弹
execute if score bullet_res int matches ..0 run return run function mot_scatter:load_bullet
# 发射子弹
execute as 0-0-0-0-0 run function mot_scatter:shoot_bullet