#mot_uav:_init
# 初始化mot_uav包

forceload add -1 -1 1 1


scoreboard objectives add vx dummy
scoreboard objectives add vy dummy
scoreboard objectives add vz dummy
scoreboard objectives add angular_x dummy
scoreboard objectives add angular_y dummy
scoreboard objectives add angular_z dummy
scoreboard objectives add angular_len dummy
scoreboard objectives add x dummy
scoreboard objectives add y dummy
scoreboard objectives add z dummy
scoreboard objectives add ivec_x dummy
scoreboard objectives add ivec_y dummy
scoreboard objectives add ivec_z dummy
scoreboard objectives add jvec_x dummy
scoreboard objectives add jvec_y dummy
scoreboard objectives add jvec_z dummy
scoreboard objectives add kvec_x dummy
scoreboard objectives add kvec_y dummy
scoreboard objectives add kvec_z dummy
scoreboard objectives add quat_x dummy
scoreboard objectives add quat_y dummy
scoreboard objectives add quat_z dummy
scoreboard objectives add quat_w dummy
scoreboard objectives add quat_start_x dummy
scoreboard objectives add quat_start_y dummy
scoreboard objectives add quat_start_z dummy
scoreboard objectives add quat_start_w dummy
scoreboard objectives add quat_orth_x dummy
scoreboard objectives add quat_orth_y dummy
scoreboard objectives add quat_orth_z dummy
scoreboard objectives add quat_orth_w dummy
scoreboard objectives add quat_phi dummy

scoreboard objectives add int dummy
scoreboard players set -1 int -1
scoreboard players set 0 int 0
scoreboard players set 1 int 1
scoreboard players set 2 int 2
scoreboard players set 3 int 3
scoreboard players set 4 int 4
scoreboard players set 5 int 5
scoreboard players set 10 int 10
scoreboard players set 100 int 100
scoreboard players set 1000 int 1000
scoreboard players set 10000 int 10000

function mot_uav:_consts

function mot_uav:_class

function mot_uav:display/init