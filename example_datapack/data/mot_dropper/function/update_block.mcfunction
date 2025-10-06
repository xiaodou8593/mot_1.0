#mot_dropper:update_block
# mot_dropper:grab_block调用
# mot_dropper:place_block调用
# mot_dropper:set_operations调用

data modify storage mot_dropper:io temp set value {}
data modify storage mot_dropper:io temp.Name set from storage mot_mover:io block_id
data modify storage mot_dropper:io temp.Properties set from storage mot_mover:io block_state
execute on passengers run data modify entity @s block_state set from storage mot_dropper:io temp