#mot_laser:bullet/_new
# 生成机枪子弹实例
# 输入数据模板[storage mot_laser:io input]
# 输出实例entity @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon marker 0 0 0 {Tags:["mot_laser_bullet","result"],CustomName:'"mot_laser_bullet"'}
execute as @e[tag=result,limit=1] run function mot_laser:bullet/set