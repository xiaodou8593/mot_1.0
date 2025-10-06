#mot_uav:fans/main
# mot_uav:main调用

# 机翼音效
execute if score fans_power int matches 50.. run function mot_uav:fans/sound
scoreboard players add fans_timer int 1

# 提供上升加速度
scoreboard players operation vy int += fans_power int

# 角速度阻尼
execute if score fans_power int >= mot_uav_ft int as 0-0-0-0-0 run function mot_uav:fans/spin

# 同步四元数姿态到机翼
#execute store result storage math:io xyzw[0] float 0.0001 run scoreboard players get rquat_x int
#execute store result storage math:io xyzw[1] float 0.0001 run scoreboard players get rquat_y int
#execute store result storage math:io xyzw[2] float 0.0001 run scoreboard players get rquat_z int
#execute store result storage math:io xyzw[3] float 0.0001 run scoreboard players get rquat_w int
#execute on passengers if entity @s[tag=fan] run function mot_uav:fans/sync_rr

# 按比例增加fans_theta
scoreboard players operation sstemp int = fans_power int
scoreboard players operation sstemp int *= mot_uav_fr int
scoreboard players operation fans_theta int -= sstemp int

# 计算本地四元数
scoreboard players operation theta int = fans_theta int
execute as 0-0-0-0-0 run function math:iquat/_theta_to
execute on passengers if entity @s[tag=fan] run function math:iquat/_store

# 关闭静体优化
scoreboard players set motion_static int 0

# 运行控制程序
execute if score temp_c int matches 1 run return fail
scoreboard players operation tempid int = @s mot_uav_id
execute if data storage mot_uav:io program.pointer as 0-0-0-0-0 run function mot_uav:fans/run_program with storage mot_uav:io program