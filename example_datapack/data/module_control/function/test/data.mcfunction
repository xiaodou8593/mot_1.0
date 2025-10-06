#module_control:test/data
# 聊天栏运行测试

tellraw @a "--- module_control data test ---"

# 注册模块a, b
tellraw @a "[test] reg a, b"
function module_control:test/module_a/_init
function module_control:test/module_b/_init
function module_control:data/_print

# 查询模块a
tellraw @a "[test] query a"
scoreboard players operation inp int = #module_control:test/module_a/ module_id
function module_control:data/_query
tellraw @a ["result: ", {"nbt":"result","storage":"module_control:io"}]

# 查询模块b
tellraw @a "[test] query b"
scoreboard players operation inp int = #module_control:test/module_b/ module_id
function module_control:data/_query
tellraw @a ["result: ", {"nbt":"result","storage":"module_control:io"}]

# 删除模块a
tellraw @a "[test] del a"
scoreboard players operation inp int = #module_control:test/module_a/ module_id
function module_control:data/_del
function module_control:data/_print

# 注册模块c
tellraw @a "[test] reg c"
data modify storage module_control:io input set value {prefix:"module_control:test/module_c/",namespace:"module_control"}
function module_control:data/_reg
scoreboard players operation #module_control:test/module_c/ module_id = res int
function module_control:data/_print

# 删除模块c, b
tellraw @a "[test] del c, b"
scoreboard players operation inp int = #module_control:test/module_c/ module_id
function module_control:data/_del
scoreboard players operation inp int = #module_control:test/module_b/ module_id
function module_control:data/_del
function module_control:data/_print