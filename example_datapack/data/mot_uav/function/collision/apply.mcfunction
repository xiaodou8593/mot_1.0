#mot_uav:collision/apply
# mot_uav:main调用

# 获取冲量数量
execute store result score cnt_impulse int run data get storage mot_uav:io list_impulse

# 求解冲量的向量部分之和
scoreboard players set vec_x int 0
scoreboard players set vec_y int 0
scoreboard players set vec_z int 0
scoreboard players operation loop int = cnt_impulse int
function mot_uav:collision/sum_loop

# 着陆条件判定
function math:vec/_energy
scoreboard players operation res int > 1 int
execute if score res int < mot_uav_st int as 0-0-0-0-0 run function mot_uav:collision/surface
# 如果着陆就不再运行碰撞
execute if score res int matches 0 run return run data modify storage mot_uav:io list_impulse set value []

# 遍历并施加每个冲量
function mot_uav:collision/apply_loop

scoreboard players set temp_c int 1