#mot_mover:update_block
# mot_mover:grab_block调用
# mot_mover:place_block调用
# mot_mover:set_operations调用

data modify storage mot_mover:io temp set value {}
data modify storage mot_mover:io temp.Name set from storage mot_mover:io block_id
data modify storage mot_mover:io temp.Properties set from storage mot_mover:io block_state
execute on passengers run data modify entity @s block_state set from storage mot_mover:io temp