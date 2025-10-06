#mot_scenes:exhibition/next_state
# mot_scenes:exhibition/$(state)/main调用

# 所有状态运行结束则提前返回
execute unless data storage mot_scenes:io list_states[0] run \
	return run data modify storage marker_control:io result.state set value "end"

# 状态切换
data modify storage mot_scenes:io input set from storage mot_scenes:io list_states[0]
data remove storage mot_scenes:io list_states[0]
function mot_scenes:exhibition/enter_state with storage mot_scenes:io input