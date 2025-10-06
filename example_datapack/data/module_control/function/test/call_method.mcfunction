#module_control:test/call_method
# 聊天栏运行测试

tellraw @a "--- module_control call_method test ---"

# 注册模块a, b
tellraw @a "[test] reg a, b"
function module_control:test/module_a/_init
function module_control:test/module_b/_init

# 生成实例abaab
tellraw @a "[test] new a, b, a, a, b"
tag @e[tag=test] remove test
function module_control:test/module_a/_new
tag @e[tag=result,limit=1] add test
function module_control:test/module_b/_new
tag @e[tag=result,limit=1] add test
function module_control:test/module_a/_new
tag @e[tag=result,limit=1] add test
function module_control:test/module_a/_new
tag @e[tag=result,limit=1] add test
function module_control:test/module_b/_new
tag @e[tag=result,limit=1] add test

# 输出实例abaab
tellraw @a "[test] say a, b, a, a, b"
execute as @e[tag=test] run function module_control:_call_method {path:"_say"}

# 删除实例abaab
tellraw @a "[test] kill a, b, a, a, b"
kill @e[tag=test]

# 删除模块a, b
tellraw @a "[test] del a, b"
scoreboard players operation inp int = #module_control:test/module_a/ module_id
function module_control:data/_del
scoreboard players operation inp int = #module_control:test/module_b/ module_id
function module_control:data/_del