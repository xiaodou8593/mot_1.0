#mot_uav:down_slot/_deconnect
# 输入mot_uav临时对象

# 生成断连冲量
scoreboard players set u int 0
scoreboard players set v int -2500
scoreboard players set w int 0
function math:uvw/_tofvec
scoreboard players operation impulse_x int = x int
scoreboard players operation impulse_y int = y int
scoreboard players operation impulse_z int = z int
scoreboard players operation impulse_x int += fvec_x int
scoreboard players operation impulse_y int += fvec_y int
scoreboard players operation impulse_z int += fvec_z int
scoreboard players set u int 0
scoreboard players set v int 0
scoreboard players set w int 2500
function math:uvw/_tofvec
scoreboard players operation impulse_fx int = fvec_x int
scoreboard players operation impulse_fy int = fvec_y int
scoreboard players operation impulse_fz int = fvec_z int
function mot_uav:impulse/_model

# 为断连设备添加冲量
data modify storage mot_uav:io input set from storage mot_uav:io result
execute as @e[tag=mot_device] if score @s mot_uav_id = down_slot_id int run function mot_uav:impulse/_append

# 完成单方向断连
scoreboard players set down_slot_id int 0