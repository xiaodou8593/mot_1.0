#mot_uav:collision/_get_norm
# 获取当前位置所在地形的法向量
# 输入执行位置
# 输出nvec{<nvec_x,int,1w>, <nvec_y,int,1w>, <nvec_z,int,1w>}
# 需要以世界实体为执行者

tp @s ~ ~ ~
data modify storage math:io xyz set from entity @s Pos
execute store result score sstemp_xn int run data get storage math:io xyz[0] 10000
execute store result score sstemp_yn int run data get storage math:io xyz[1] 10000
execute store result score sstemp_zn int run data get storage math:io xyz[2] 10000

# 利用取余计算方块内坐标
scoreboard players operation sstemp_xn int %= 10000 int
scoreboard players operation sstemp_yn int %= 10000 int
scoreboard players operation sstemp_zn int %= 10000 int

# 面法向量的优先级(按从小到大排序) = 有邻近方块*10000 + (当前位置到面的距离-1)

scoreboard players set sstemp_xp int 9999
scoreboard players operation sstemp_xp int -= sstemp_xn int
execute unless block ~1 ~ ~ #mot_uav:pass run scoreboard players add sstemp_xp int 10000

scoreboard players set sstemp_yp int 9999
scoreboard players operation sstemp_yp int -= sstemp_yn int
execute unless block ~ ~1 ~ #mot_uav:pass run scoreboard players add sstemp_yp int 10000

scoreboard players set sstemp_zp int 9999
scoreboard players operation sstemp_zp int -= sstemp_zn int
execute unless block ~ ~ ~1 #mot_uav:pass run scoreboard players add sstemp_zp int 10000

execute unless block ~-1 ~ ~ #mot_uav:pass run scoreboard players add sstemp_xn int 10000
execute unless block ~ ~-1 ~ #mot_uav:pass run scoreboard players add sstemp_yn int 10000
execute unless block ~ ~ ~-1 #mot_uav:pass run scoreboard players add sstemp_zn int 10000

# 获取优先级排序第一名
scoreboard players operation sstemp_min int = sstemp_xp int
scoreboard players operation sstemp_min int < sstemp_xn int
scoreboard players operation sstemp_min int < sstemp_yp int
scoreboard players operation sstemp_min int < sstemp_yn int
scoreboard players operation sstemp_min int < sstemp_zp int
scoreboard players operation sstemp_min int < sstemp_zn int

# 输出法向量
scoreboard players set nvec_x int 0
scoreboard players set nvec_y int 0
scoreboard players set nvec_z int 0

execute if score sstemp_xp int = sstemp_min int run return run scoreboard players set nvec_x int 10000
execute if score sstemp_xn int = sstemp_min int run return run scoreboard players set nvec_x int -10000
execute if score sstemp_yp int = sstemp_min int run return run scoreboard players set nvec_y int 10000
execute if score sstemp_yn int = sstemp_min int run return run scoreboard players set nvec_y int -10000
execute if score sstemp_zp int = sstemp_min int run return run scoreboard players set nvec_z int 10000
execute if score sstemp_zn int = sstemp_min int run return run scoreboard players set nvec_z int -10000