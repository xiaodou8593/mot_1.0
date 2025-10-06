#mot_boat:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_boat:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon oak_boat ~ ~ ~ {Tags:["mot_boat", "result", "mot_device"]}
execute as @e[tag=result,limit=1] run function mot_boat:set
execute as @e[tag=result,limit=1] run function mot_boat:set_operations