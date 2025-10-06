#mot_mover:block/_zero
# 把临时对象置零

data modify storage mot_mover:io block_id set value ""
data modify storage mot_mover:io block_state set value {}
data modify storage mot_mover:io block_nbt set value {}