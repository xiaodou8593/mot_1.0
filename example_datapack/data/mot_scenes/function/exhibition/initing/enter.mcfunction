#mot_scenes:exhibition/initing/enter
# 进入初始化状态

# 打开机翼电机
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:fans/_on

# 上传高度程序
data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"up"}]
data modify storage mot_uav:io program.delta_y set value 2.0d
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_store_program

# 状态切换
data modify storage marker_control:io result.state set value "initing"