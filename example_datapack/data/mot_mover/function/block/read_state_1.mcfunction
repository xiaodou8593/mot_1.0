#mot_mover:block/read_state_1
# mot_mover:block/_read调用

# 读取type
execute if predicate {"condition":"location_check","predicate":{"block":{"state":{"type":"single"}}}} run \
	data modify storage mot_mover:io block_state.type set value "single"
execute if predicate {"condition":"location_check","predicate":{"block":{"state":{"type":"left"}}}} run \
	data modify storage mot_mover:io block_state.type set value "left"
execute if predicate {"condition":"location_check","predicate":{"block":{"state":{"type":"right"}}}} run \
	data modify storage mot_mover:io block_state.type set value "right"