#mot_mover:block/_place
# 放置方块
# 输出block ~ ~ ~

# 对方块状态进行字符串处理
function mot_mover:block/state_string with storage mot_mover:io {}
function perf:utils/string/_from_raw
# 提高大括号为方括号
data modify storage math:io string_chars[0] set value {char:"["}
data modify storage math:io string_chars[-1] set value {char:"]"}
# 替换所有的冒号为等号
data modify storage math:io input set value [{":":1b,range:[1,1]}]
function mot_mover:block/string_loop
# 输出字符串
function perf:utils/string/_to_raw
data modify storage mot_mover:io state_string set from storage math:io result

# 宏拼接setblock
function mot_mover:block/setblock with storage mot_mover:io {}

# 设置方块实体NBT
execute if data storage mot_mover:io block_nbt.id run \
	data modify block ~ ~ ~ {} merge from storage mot_mover:io block_nbt