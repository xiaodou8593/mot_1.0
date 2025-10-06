#mot_mover:block/read_state_0
# mot_mover:block/_read调用

# 读取facing
execute if predicate {"condition":"location_check","predicate":{"block":{"state":{"facing":"north"}}}} run \
	data modify storage mot_mover:io block_state.facing set value "north"
execute if predicate {"condition":"location_check","predicate":{"block":{"state":{"facing":"south"}}}} run \
	data modify storage mot_mover:io block_state.facing set value "south"
execute if predicate {"condition":"location_check","predicate":{"block":{"state":{"facing":"east"}}}} run \
	data modify storage mot_mover:io block_state.facing set value "east"
execute if predicate {"condition":"location_check","predicate":{"block":{"state":{"facing":"west"}}}} run \
	data modify storage mot_mover:io block_state.facing set value "west"

# 读取waterlogged
execute if predicate {"condition":"location_check","predicate":{"block":{"state":{"waterlogged":"false"}}}} run \
	data modify storage mot_mover:io block_state.waterlogged set value "false"
execute if predicate {"condition":"location_check","predicate":{"block":{"state":{"waterlogged":"true"}}}} run \
	data modify storage mot_mover:io block_state.waterlogged set value "true"