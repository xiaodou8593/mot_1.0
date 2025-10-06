#mot_uav:raycast
# mot_uav:tick调用

# 保证玩家已经被初始化为一个时钟周期小于等于3的iframe_ray对象
execute unless entity @s[tag=iframe_ray] run return run function iframe:ray/_prescript_3
execute if score @s iframe_ray_per > 3 int run return run function iframe:ray/_unbe

# 视线追踪返回值为空提前返回
execute if score @s iframe_ray_res matches 0 run return fail

# 检测视线追踪的返回值，获取编号
scoreboard players set res int 0
scoreboard players operation tempid int = @s iframe_ray_ptr
execute as @e[tag=mot_uav] if score @s iframe_oid = tempid int \
	store success score res int run \
	scoreboard players operation tempid int = @s mot_uav_id
execute if score res int matches 0 run return fail

# 检查玩家背包的控制权限是否包含编号
execute store result storage mot_uav:io tempid int 1 run scoreboard players get tempid int
data modify storage mot_uav:io temp set value []
data modify storage mot_uav:io temp append from \
	entity @s Inventory[].components."minecraft:custom_data"{mot_uav:"controller"}.mot_uav_id
execute store result score res int run data get storage mot_uav:io temp
execute store result score temp int run data modify storage mot_uav:io temp[] set from storage mot_uav:io tempid
scoreboard players operation res int -= temp int
execute if score res int matches 0 run return fail

# 进入对应编号无人机的选中界面
data modify storage iframe:io input set value "mot_uav:guis/selected"
function iframe:_enter
function iframe:_inv
function iframe:player_space/_get
data modify storage iframe:io result.mot_uav_id set from storage mot_uav:io tempid
function iframe:player_space/_store