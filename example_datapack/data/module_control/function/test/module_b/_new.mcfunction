#module_control:test/module_b/_new
# 生成module_b实例
# 输出entity @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon marker 0 0 0 {Tags:["result", "module_b"]}
scoreboard players operation @e[tag=result,limit=1] module_id = #module_control:test/module_b/ module_id