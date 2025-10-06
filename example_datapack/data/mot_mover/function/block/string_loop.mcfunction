#mot_mover:block/string_loop
# mot_mover:block/_place调用

function perf:utils/string/_find
# 查找结束
execute if score res int matches 0 run return fail

# 冒号替换为等号
data modify storage math:io string_chars[0] set value {char:"="}

# 继续查找
function mot_mover:block/string_loop