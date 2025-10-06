#module_control:test/module_a/_new
# 生成module_a实例
# 输出entity @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon marker 0 0 0 {Tags:["result", "module_a"]}
scoreboard players operation @e[tag=result,limit=1] module_id = #module_control:test/module_a/ module_id