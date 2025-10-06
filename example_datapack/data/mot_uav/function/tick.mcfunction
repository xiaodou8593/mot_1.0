#mot_uav:tick

# 玩家物品栏更新检测
execute as @a[tag=mot_uav_inv_c] run function mot_uav:inv_detect

# 无人机主程序入口
execute if entity @e[tag=mot_uav,limit=1] if function mot_uav:collision/_load_data as @e[tag=mot_uav] run function mot_uav:main

# 玩家视线搜索程序入口
execute as @a[tag=mot_uav_player,tag=!iframe_player] run function mot_uav:raycast