# 第三章：设备系统

## 第一节：模块与设备系统

### 3.1.1 模块控制

回到data目录，创建新的命名空间module_control

命名空间内创建function文件夹

创建module_control:_init

```
#module_control:_init
# 初始化模块控制

# 储存模块信息的数据结构
data modify storage module_control:io prefix_dict set value {}
data modify storage module_control:io list_infos set value []

# 建立编号池
data modify storage module_control:io free_addr set value []

scoreboard objectives add module_id dummy
# 编号从0开始以便访问列表下标
scoreboard players set #id module_id -1

# 外部访问初始化状态
scoreboard objectives add int dummy
scoreboard players set module_control_inited int 1
```

function文件夹内创建data目录

![alt text](images/image-143.png)

创建module_control:data/.doc.mcfo

```
#module_control:data/doc.mcfo

# 模块信息协议
_input_plate: {
	prefix: [storage module_control:io input.prefix, String],
	namespace: [storage module_control:io input.namespace, String]
}
```

创建module_control:data/_reg

```
#module_control:data/_reg
# 注册模块信息
# 输入storage module_control:io input
# 输出编号<res,int>

# 检查是否已经注册该路径
execute store result score res int run function module_control:data/check_dict with storage module_control:io input

# 如果已经注册路径
execute if score res int matches 1 run return run function module_control:data/replace_info

# 如果未注册路径
execute unless data storage module_control:io free_addr[0] run function module_control:new_addr
execute store result storage module_control:io index int 1 \
	store result score res int \
	run data get storage module_control:io free_addr[0]
data remove storage module_control:io free_addr[0]

function module_control:data/set_dict with storage module_control:io input
function module_control:data/replace_index with storage module_control:io {}
```

创建module_control:data/check_dict

```
#module_control:data/check_dict
# module_control:data/_reg调用

$return run execute if data storage module_control:io prefix_dict.$(prefix)
```

创建module_control:data/replace_info

```
#module_control:data/replace_info
# module_control:data/_reg调用

# 获取路径的编号
execute store result storage module_control:io index int 1 \
	store result score res int \
	run function module_control:data/get_dict with storage module_control:io input

# 替换模块信息
function module_control:data/replace_index with storage module_control:io {}
```

创建module_control:data/get_dict

```
#module_control:data/get_dict
# module_control:data/replace_info调用

$return run data get storage module_control:io prefix_dict.$(prefix)
```

创建module_control:data/replace_index

```
#module_control:data/replace_index
# module_control:data/replace_info调用
# module_control:data/_reg调用

$data modify storage module_control:io list_infos[$(index)] set from storage module_control:io input
```

创建module_control:new_addr

```
#module_control:new_addr
# module_control:data/_reg调用

data modify storage module_control:io free_addr prepend value 0
execute store result storage module_control:io free_addr[0] int 1 run scoreboard players add #id module_id 1

data modify storage module_control:io list_infos append value {}
```

创建module_control:data/set_dict

```
#module_control:data/set_dict
# module_control:data/_reg调用

$data modify storage module_control:io prefix_dict.$(prefix) set from storage module_control:io index
```

创建module_control:data/_del

```
#module_control:data/_del
# 删除模块信息
# 输入编号<inp,int>
# 输出模块信息storage module_control:io result

# 弹出模块信息
execute store result storage module_control:io index int 1 run scoreboard players get inp int
function module_control:data/get_index with storage module_control:io {}

# 删除路径
function module_control:data/rmv_dict with storage module_control:io result

# 释放编号
data modify storage module_control:io free_addr prepend from storage module_control:io index
```

创建module_control:data/get_index

```
#module_control:data/get_index
# module_control:data/_del调用

$data modify storage module_control:io result set from storage module_control:io list_infos[$(index)]
```

创建module_control:data/rmv_dict

```
#module_control:data/rmv_dict
# module_control:data/_del调用

$data remove storage module_control:io prefix_dict.$(prefix)
```

创建module_control:data/_query

```
#module_control:data/_query
# 查询模块信息
# 输入编号<inp,int>
# 输出模块信息storage module_control:io result

# 弹出模块信息
execute store result storage module_control:io index int 1 run scoreboard players get inp int
function module_control:data/get_index with storage module_control:io {}
```

修改module_control:data/get_index

```
#module_control:data/get_index
# module_control:data/_del调用
# module_control:data/_query调用

$data modify storage module_control:io result set from storage module_control:io list_infos[$(index)]
```

创建module_control:data/_print

```
#module_control:data/_print
# 输出模块数据结构调试信息

tellraw @a "module_data: {"
tellraw @a ["    prefix_dict: ",{"nbt":"prefix_dict","storage":"module_control:io"}]
tellraw @a ["    list_infos: ",{"nbt":"list_infos","storage":"module_control:io"}]
tellraw @a "}"
```

创建module_control:_call_method

```
#module_control:_call_method
# 调用模块实例的方法
# 以模块实例为执行者
# 输入macro {path:""}
# 输出storage module_control:io result

# 弹出模块信息
execute store result storage module_control:io index int 1 run scoreboard players get @s module_id
function module_control:data/get_index with storage module_control:io {}

$data modify storage module_control:io result.path set value "$(path)"
function module_control:run_func with storage module_control:io result
```

修改module_control:data/get_index

```
#module_control:data/get_index
# module_control:data/_del调用
# module_control:data/_query调用
# module_control:_call_method调用

$data modify storage module_control:io result set from storage module_control:io list_infos[$(index)]
```

创建module_control:run_func

```
#module_control:run_func
# module_control:_call_method调用

$function $(prefix)$(path)
```

在function目录下创建test文件夹

在test目录下创建两个模块: module_a, module_b

![alt text](images/image-144.png)

创建module_control:test/module_a/_init

```
#module_control:test/module_a/_init
# 初始化module_a

# 初始化模块控制
scoreboard objectives add int dummy
execute unless score module_control_inited int matches 1 run function module_control:_init

# 注册本模块
data modify storage module_control:io input set value {prefix:"module_control:test/module_a/",namespace:"module_control"}
function module_control:data/_reg
scoreboard players operation #module_control:test/module_a/ module_id = res int
```

创建module_control:test/module_a/_new

```
#module_control:test/module_a/_new
# 生成module_a实例
# 输出entity @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon marker 0 0 0 {Tags:["result", "module_a"]}
scoreboard players operation @e[tag=result,limit=1] module_id = #module_control:test/module_a/ module_id
```

创建module_control:test/module_a/_say

```
#module_control:test/module_a/_say
# 实例说话
# 以实例为执行者

say meow
```

创建module_control:test/module_b/_init

```
#module_control:test/module_b/_init
# 初始化module_b

# 初始化模块控制
scoreboard objectives add int dummy
execute unless score module_control_inited int matches 1 run function module_control:_init

# 注册本模块
data modify storage module_control:io input set value {prefix:"module_control:test/module_b/",namespace:"module_control"}
function module_control:data/_reg
scoreboard players operation #module_control:test/module_b/ module_id = res int
```

创建module_control:test/module_b/_new

```
#module_control:test/module_b/_new
# 生成module_b实例
# 输出entity @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon marker 0 0 0 {Tags:["result", "module_b"]}
scoreboard players operation @e[tag=result,limit=1] module_id = #module_control:test/module_b/ module_id
```

创建module_control:test/module_b/_say

```
#module_control:test/module_b/_say
# 实例说话
# 以实例为执行者

say woof
```

创建module_control:test/data

```
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
```

创建module_control:test/call_method

```
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
```

进入游戏运行测试

```
reload
function module_control:test/data
```

![alt text](images/image-145.png)

```
function module_control:test/call_method
```

![alt text](images/image-146.png)

测试所有功能正常

### 3.1.2 构建设备系统

为了给其它外接设备设计不同的碰撞数据，

我们将常量mot_uav_ch, collision_points修改为可变量

打开mot终端，添加collision/_load_data

```
cre collision/_load_data
```

![alt text](images/image-147.png)

编写collision/_load_data

```
#mot_uav:collision/_load_data
# 加载无人机碰撞数据

# 着陆底盘距离
scoreboard players set mot_uav_ch int 2500

# 碰撞点列表
data modify storage mot_uav:io collision_points set value [\
	[-0.25d, -0.25d, -0.25d],\
	[-0.25d, -0.25d, 0.25d],\
	[-0.25d, 0.25d, -0.25d],\
	[-0.25d, 0.25d, 0.25d],\
	[0.25d, -0.25d, -0.25d],\
	[0.25d, -0.25d, 0.25d],\
	[0.25d, 0.25d, -0.25d],\
	[0.25d, 0.25d, 0.25d]\
]

# 是否加载完成
return 1
```

修改tick函数，调用collision/_load_data

```
#mot_uav:tick

# 玩家物品栏更新检测
execute as @a[tag=mot_uav_inv_c] run function mot_uav:inv_detect

# 无人机主程序入口
execute if entity @e[tag=mot_uav,limit=1] if function mot_uav:collision/_load_data as @e[tag=mot_uav] run function mot_uav:main

# 玩家视线搜索程序入口
execute as @a[tag=mot_uav_player,tag=!iframe_player] run function mot_uav:raycast
```

为了允许外部向无人机添加冲量，我们将list_impulse修改为无人机的属性

注释main函数第40行

```
#mot_uav:main
# mot_uav:tick调用
# 实体对象主程序

...

# 遍历碰撞点列表
#data modify storage mot_uav:io list_impulse set value []
execute store result score loop int run data get storage mot_uav:io collision_points
execute if score loop int matches 1.. as 0-0-0-0-0 run function mot_uav:collision/loop
scoreboard players set temp_c int 0
execute if data storage mot_uav:io list_impulse[0] run function mot_uav:collision/apply

...
```

修改collision/apply第19行，清空积攒的冲量

```
#mot_uav:collision/apply
# mot_uav:main调用

...
# 如果着陆就不再运行碰撞
execute if score res int matches 0 run return run data modify storage mot_uav:io list_impulse set value []

...
```

修改.doc.mcfo，添加list_impulse属性

```
#mot_uav:doc.mcfo

# 临时对象
_this:{
	...
	static:<motion_static,int>,
	list_impulse:[storage mot_uav:io list_impulse,ListCompound],
	velocity:{<vx,int,1w>, <vy,int,1w>, <vz,int,1w>},
	...
}
```

打开mot终端，输入回车，同步数据接口

![alt text](images/image-148.png)

在mot中创建impulse/_append, impulse/_append_list接口

```
cre impulse/_append impulse/_append_list
```

![alt text](images/image-153.png)

编写impulse/_append

```
#mot_uav:impulse/_append
# 外部添加冲量
# 输入冲量数据模板storage mot_uav:io input
# 以mot_uav实例为执行者

data modify entity @s item.components."minecraft:custom_data".list_impulse append from storage mot_uav:io input
```

编写impulse/_append_list

```
#mot_uav:impulse/_append_list
# 外部批量添加冲量
# 输入冲量列表storage mot_uav:io input
# 以mot_uav实例为执行者

data modify entity @s item.components."minecraft:custom_data".list_impulse append from storage mot_uav:io input[]
```

创建device文件夹

创建device/.doc.mcfo

```
#mot_uav:device/doc.mcfo

# 外接设备协议
_this: {
	<mot_uav_root,int>
}

_interface: {
	_sync_request: {
		input: {
			<inp,int>,
			[storage mot_uav:io slot_type,String]
		},
		result: <res,int>
	},
	_sync_coord: {
		input: {
			mot_uav,
			vec: {
				<vec_x,int,1w>,
				<vec_y,int,1w>,
				<vec_z,int,1w>
			}
		},
	},
	_use_signal: {
		result: <res,int>
	}
}
```

修改mot_uav:_new，无人机本体也被视为一种设备

```
#mot_uav:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_uav:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon item_display ~ ~ ~ {Tags:["mot_uav", "result", "mot_device"],\
	...
}
...
```

打开mot终端，创建device/_main_motion, device/_main_sync, device/_sync_request, device/_sync_coord

```
cre device/_main_motion device/_main_sync device/_sync_request device/_sync_coord
```

![alt text](images/image-151.png)

以上接口作为外接设备的预制代码

外接设备可以直接使用这些代码，也可以有自己的特殊实现

编写device/_main_motion，直接照搬mot_uav:main中的物理逻辑

```
#mot_uav:device/_main_motion

# 静体优化
execute unless score motion_static int matches 0 as 0-0-0-0-0 if function mot_uav:static/detect run return fail

# 速度迭代
scoreboard players operation x int += vx int
scoreboard players operation y int += vy int
scoreboard players operation z int += vz int

# 角速度的四元数迭代
scoreboard players operation quat_phi int += angular_len int
execute as 0-0-0-0-0 run function math:quat/_xyzw
# 四元数姿态同步到局部坐标系
function math:quat/_touvw

# 速度阻尼
scoreboard players operation vx int *= mot_uav_k int
scoreboard players operation vy int *= mot_uav_k int
scoreboard players operation vz int *= mot_uav_k int
execute if score vx int matches ..-1 run scoreboard players add vx int 9999
execute if score vy int matches ..-1 run scoreboard players add vy int 9999
execute if score vz int matches ..-1 run scoreboard players add vz int 9999
scoreboard players operation vx int /= 10000 int
scoreboard players operation vy int /= 10000 int
scoreboard players operation vz int /= 10000 int

# 角速度阻尼
scoreboard players operation inp int = mot_uav_ak int
function mot_uav:angular/_factor

# 重力加速度
scoreboard players operation vy int -= mot_uav_g int

# 遍历碰撞点列表
#data modify storage mot_uav:io list_impulse set value []
execute store result score loop int run data get storage mot_uav:io collision_points
execute if score loop int matches 1.. as 0-0-0-0-0 run function mot_uav:collision/loop
scoreboard players set temp_c int 0
execute if data storage mot_uav:io list_impulse[0] run function mot_uav:collision/apply

# 同步实体坐标
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get x int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players get y int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get z int
data modify entity @s Pos set from storage math:io xyz

# 同步四元数姿态
execute store result storage math:io xyzw[0] float 0.0001 run scoreboard players get quat_x int
execute store result storage math:io xyzw[1] float 0.0001 run scoreboard players get quat_y int
execute store result storage math:io xyzw[2] float 0.0001 run scoreboard players get quat_z int
execute store result storage math:io xyzw[3] float 0.0001 run scoreboard players get quat_w int
# 成功修改姿态才会播放插值动画
data modify storage mot_uav:io cmp set from entity @s transformation.left_rotation
data modify entity @s transformation.left_rotation set from storage math:io xyzw
execute store success score sres int run data modify storage mot_uav:io cmp set from entity @s transformation.left_rotation
execute if score sres int matches 1 run data modify entity @s start_interpolation set value 0
execute on passengers if entity @s[tag=!local_quat] run function mot_uav:display/sync_pose
execute on passengers if entity @s[tag=local_quat] run function mot_uav:display/sync_local
```

编写device/_main_sync，实现姿态同步算法，然后确认连接是否断开

```
#mot_uav:device/_main_sync

function math:vec/_get

# 连接确认
scoreboard players set res int 0
execute as @e[tag=mot_device] if score @s mot_uav_id = mot_uav_root int run function module_control:_call_method {path:"_get_slot_id"}
execute unless score res int = @s mot_uav_id run return run scoreboard players set mot_uav_root int 0

# 缓存原点坐标
scoreboard players operation tempx int = x int
scoreboard players operation tempy int = y int
scoreboard players operation tempz int = z int

# 计算xyz坐标使得插槽坐标重合
scoreboard players operation u int = mot_sync_u int
scoreboard players operation v int = mot_sync_v int
scoreboard players operation w int = mot_sync_w int
function math:uvw/_tofvec
scoreboard players operation x int = vec_x int
scoreboard players operation y int = vec_y int
scoreboard players operation z int = vec_z int
scoreboard players operation x int -= fvec_x int
scoreboard players operation y int -= fvec_y int
scoreboard players operation z int -= fvec_z int

# 计算线速度
scoreboard players operation vec_x int = angular_x int
scoreboard players operation vec_y int = angular_y int
scoreboard players operation vec_z int = angular_z int
scoreboard players operation fvec_x int = x int
scoreboard players operation fvec_y int = y int
scoreboard players operation fvec_z int = z int
scoreboard players operation fvec_x int -= tempx int
scoreboard players operation fvec_y int -= tempy int
scoreboard players operation fvec_z int -= tempz int
function math:vec/_cross_fvec
# 转换弧度制
scoreboard players operation vec_x int *= 349 int
scoreboard players operation vec_y int *= 349 int
scoreboard players operation vec_z int *= 349 int
scoreboard players operation vec_x int /= 10000 int
scoreboard players operation vec_y int /= 10000 int
scoreboard players operation vec_z int /= 10000 int
# 叠加平动速度
scoreboard players operation vx int += vec_x int
scoreboard players operation vy int += vec_y int
scoreboard players operation vz int += vec_z int

# 碰撞检测
execute store result score loop int run data get storage mot_uav:io collision_points
execute if score loop int matches 1.. as 0-0-0-0-0 run function mot_uav:collision/loop

# 发送冲量
execute if data storage mot_uav:io list_impulse[0] as @e[tag=mot_device] if score @s mot_uav_id = mot_uav_root int run function mot_uav:device/connect_receive

# 同步实体坐标
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get x int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players get y int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get z int
data modify entity @s Pos set from storage math:io xyz

# 同步四元数姿态
execute store result storage math:io xyzw[0] float 0.0001 run scoreboard players get quat_x int
execute store result storage math:io xyzw[1] float 0.0001 run scoreboard players get quat_y int
execute store result storage math:io xyzw[2] float 0.0001 run scoreboard players get quat_z int
execute store result storage math:io xyzw[3] float 0.0001 run scoreboard players get quat_w int
# 成功修改姿态才会播放插值动画
data modify storage mot_uav:io cmp set from entity @s transformation.left_rotation
data modify entity @s transformation.left_rotation set from storage math:io xyzw
execute store success score sres int run data modify storage mot_uav:io cmp set from entity @s transformation.left_rotation
execute if score sres int matches 1 run data modify entity @s start_interpolation set value 0
execute on passengers if entity @s[tag=!local_quat] run function mot_uav:display/sync_pose
execute on passengers if entity @s[tag=local_quat] run function mot_uav:display/sync_local

# 关闭静体优化
scoreboard players set motion_static int 0
```

打开mot终端，创建device/connect_receive

```
cre device/connect_receive
```

![alt text](images/image-152.png)

编写device/connect_receive

```
#mot_uav:device/connect_receive
# mot_uav:device/_main_sync调用

data modify storage mot_uav:io input set from storage mot_uav:io list_impulse
function mot_uav:impulse/_append_list
data modify storage mot_uav:io list_impulse set value []
```

打开mot终端，创建_get_slot_id

```
cre _get_slot_id
```

![alt text](images/image-177.png)

编写_get_slot_id

```
#mot_uav:_get_slot_id
# 返回槽位连接编号
# 以无人机实例为执行者
# 输入storage mot_uav:io slot_type
# 输出<res,int>

execute if data storage mot_uav:io {slot_type:"left"} run scoreboard players operation res int = @s left_slot_id
execute if data storage mot_uav:io {slot_type:"down"} run scoreboard players operation res int = @s down_slot_id
execute if data storage mot_uav:io {slot_type:"right"} run scoreboard players operation res int = @s right_slot_id
```

编写device/_sync_coord

```
#mot_uav:device/_sync_coord
# 输入mot_uav临时对象
# 输入vec{<vec_x,int,1w>,<vec_y,int,1w>,<vec_z,int,1w>}
# 以外接设备实例为执行者

function math:vec/_store
function mot_uav:_store_motion
```

打开mot终端，创建_store_motion接口

```
cre _store_motion
```

![alt text](images/image-155.png)

实现_store_motion

```
#mot_uav:_store_motion
# 储存运动学数据
# 输入无人机实例

scoreboard players operation @s vx = vx int
scoreboard players operation @s vy = vy int
scoreboard players operation @s vz = vz int
scoreboard players operation @s angular_x = angular_x int
scoreboard players operation @s angular_y = angular_y int
scoreboard players operation @s angular_z = angular_z int
scoreboard players operation @s angular_len = angular_len int
scoreboard players operation @s x = x int
scoreboard players operation @s y = y int
scoreboard players operation @s z = z int
scoreboard players operation @s ivec_x = ivec_x int
scoreboard players operation @s ivec_y = ivec_y int
scoreboard players operation @s ivec_z = ivec_z int
scoreboard players operation @s jvec_x = jvec_x int
scoreboard players operation @s jvec_y = jvec_y int
scoreboard players operation @s jvec_z = jvec_z int
scoreboard players operation @s kvec_x = kvec_x int
scoreboard players operation @s kvec_y = kvec_y int
scoreboard players operation @s kvec_z = kvec_z int
scoreboard players operation @s quat_x = quat_x int
scoreboard players operation @s quat_y = quat_y int
scoreboard players operation @s quat_z = quat_z int
scoreboard players operation @s quat_w = quat_w int
scoreboard players operation @s quat_start_x = quat_start_x int
scoreboard players operation @s quat_start_y = quat_start_y int
scoreboard players operation @s quat_start_z = quat_start_z int
scoreboard players operation @s quat_start_w = quat_start_w int
scoreboard players operation @s quat_orth_x = quat_orth_x int
scoreboard players operation @s quat_orth_y = quat_orth_y int
scoreboard players operation @s quat_orth_z = quat_orth_z int
scoreboard players operation @s quat_orth_w = quat_orth_w int
scoreboard players operation @s quat_phi = quat_phi int
```

编写device/_sync_request

```
#mot_uav:device/_sync_request
# 输入请求设备编号<inp,int>
# 输入插槽类型storage mot_uav:io slot_type
# 以外接设备实例为执行者
# 输出<res,int>，同意连接?设备编号:0

# 没有连接设备则同意请求
execute if score @s mot_uav_root matches 0 run return run function mot_uav:device/agree_request

# 连接到无人机设备则拒接请求
scoreboard players operation tempid int = @s mot_uav_root
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run return run scoreboard players set res int 0

# 连接到非无人机设备则同意请求
function mot_uav:device/agree_request
```

打开mot终端，创建device/agree_request

```
cre device/agree_request
```

![alt text](images/image-156.png)

编写device/agree_request

```
#mot_uav:device/agree_request
# mot_uav:device/_sync_request调用

# 设置连接
scoreboard players operation @s mot_uav_root = inp int

# 保存插槽类型
data modify entity @s item.components."minecraft:custom_data".slot_type set from storage mot_uav:io slot_type

# 返回自身编号
scoreboard players operation res int = @s mot_uav_id
```

由于无人机本身也是一种mot_device，我们需要实现协议所需的接口

打开mot终端，创建_sync_request接口

```
cre _sync_request
```

![alt text](images/image-175.png)

编写_sync_request

```
#mot_uav:_sync_request

# 直接拒接请求
scoreboard players set res int 0
```

### 3.1.3 设备插槽

我们为无人机设计三个插槽位置：left_slot, down_slot, right_slot

修改.doc.mcfo，为无人机添加三个属性left_slot_id, down_slot_id, right_slot_id

```
#mot_uav:doc.mcfo

# 临时对象
_this:{
	left_slot_id:<left_slot_id,int>,
	down_slot_id:<down_slot_id,int>,
	right_slot_id:<right_slot_id,int>,
	...
}
```

打开mot终端，输入回车，同步数据接口

![alt text](images/image-157.png)

打开mot终端，创建left_slot, down_slot, right_slot相关接口

```
cre left_slot/main left_slot/_connect left_slot/_deconnect
```

```
cre down_slot/main down_slot/_connect down_slot/_deconnect
```

```
cre right_slot/main right_slot/_connect right_slot/_deconnect
```

![alt text](images/image-158.png)

编写left_slot/_connect, down_slot/_connect, right_slot/_connect

```
#mot_uav:left_slot/_connect
# 输入mot_uav临时对象
# 输入设备编号<inp,int>

# 完成单方向连接
scoreboard players operation left_slot_id int = inp int

# 关闭静体优化
scoreboard players set motion_static int 0
```

```
#mot_uav:down_slot/_connect
# 输入mot_uav临时对象
# 输入设备编号<inp,int>

# 完成单方向连接
scoreboard players operation down_slot_id int = inp int

# 关闭静体优化
scoreboard players set motion_static int 0
```

```
#mot_uav:right_slot/_connect
# 输入mot_uav临时对象
# 输入设备编号<inp,int>

# 完成单方向连接
scoreboard players operation right_slot_id int = inp int

# 关闭静体优化
scoreboard players set motion_static int 0
```

编写left_slot/_deconnect, down_slot/_deconnect, right_slot/_deconnect

```
#mot_uav:left_slot/_deconnect
# 输入mot_uav临时对象

# 生成断连冲量
scoreboard players set u int 2500
scoreboard players set v int 0
scoreboard players set w int 0
function math:uvw/_tofvec
scoreboard players operation impulse_x int = x int
scoreboard players operation impulse_y int = y int
scoreboard players operation impulse_z int = z int
scoreboard players operation impulse_x int += fvec_x int
scoreboard players operation impulse_y int += fvec_y int
scoreboard players operation impulse_z int += fvec_z int
scoreboard players operation impulse_fx int = fvec_x int
scoreboard players operation impulse_fy int = fvec_y int
scoreboard players operation impulse_fz int = fvec_z int
function mot_uav:impulse/_model

# 为断连设备添加冲量
data modify storage mot_uav:io input set from storage mot_uav:io result
execute as @e[tag=mot_device] if score @s mot_uav_id = left_slot_id int run function mot_uav:impulse/_append

# 完成单方向断连
scoreboard players set left_slot_id int 0
```

```
# 生成断连冲量
scoreboard players set u int 0
scoreboard players set v int -2500
scoreboard players set w int 0
function math:uvw/_tofvec
scoreboard players operation impulse_x int = x int
scoreboard players operation impulse_y int = y int
scoreboard players operation impulse_z int = z int
scoreboard players operation impulse_x int += fvec_x int
scoreboard players operation impulse_y int += fvec_y int
scoreboard players operation impulse_z int += fvec_z int
scoreboard players set u int 0
scoreboard players set v int 0
scoreboard players set w int 2500
function math:uvw/_tofvec
scoreboard players operation impulse_fx int = fvec_x int
scoreboard players operation impulse_fy int = fvec_y int
scoreboard players operation impulse_fz int = fvec_z int
function mot_uav:impulse/_model
```

```
#mot_uav:right_slot/_deconnect
# 输入mot_uav临时对象

# 生成断连冲量
scoreboard players set u int -2500
scoreboard players set v int 0
scoreboard players set w int 0
function math:uvw/_tofvec
scoreboard players operation impulse_x int = x int
scoreboard players operation impulse_y int = y int
scoreboard players operation impulse_z int = z int
scoreboard players operation impulse_x int += fvec_x int
scoreboard players operation impulse_y int += fvec_y int
scoreboard players operation impulse_z int += fvec_z int
scoreboard players operation impulse_fx int = fvec_x int
scoreboard players operation impulse_fy int = fvec_y int
scoreboard players operation impulse_fz int = fvec_z int
function mot_uav:impulse/_model

# 为断连设备添加冲量
data modify storage mot_uav:io input set from storage mot_uav:io result
execute as @e[tag=mot_device] if score @s mot_uav_id = right_slot_id int run function mot_uav:impulse/_append

# 完成单方向断连
scoreboard players set right_slot_id int 0
```

编写left_slot/main, down_slot/main, right_slot/main

```
#mot_uav:left_slot/main
# mot_uav:main调用

# 连接确认
scoreboard players set tempid int 0
execute as @e[tag=mot_device] if score @s mot_uav_id = left_slot_id int run scoreboard players operation tempid int = @s mot_uav_root
execute unless score tempid int = @s mot_uav_id run return run scoreboard players set left_slot_id int 0

# 发送姿态同步数据
scoreboard players set u int 2500
scoreboard players set v int 0
scoreboard players set w int 0
function math:uvw/_tovec
execute as @e[tag=mot_device] if score @s mot_uav_id = left_slot_id int run function module_control:_call_method {path:"_sync_coord"}
```

```
#mot_uav:down_slot/main
# mot_uav:main调用

# 连接确认
scoreboard players set tempid int 0
execute as @e[tag=mot_device] if score @s mot_uav_id = down_slot_id int run scoreboard players operation tempid int = @s mot_uav_root
execute unless score tempid int = @s mot_uav_id run return run scoreboard players set down_slot_id int 0

# 发送姿态同步数据
scoreboard players set u int 0
scoreboard players set v int -2500
scoreboard players set w int 0
function math:uvw/_tovec
execute as @e[tag=mot_device] if score @s mot_uav_id = down_slot_id int run function module_control:_call_method {path:"_sync_coord"}
```

```
#mot_uav:right_slot/main
# mot_uav:main调用

# 连接确认
scoreboard players set tempid int 0
execute as @e[tag=mot_device] if score @s mot_uav_id = right_slot_id int run scoreboard players operation tempid int = @s mot_uav_root
execute unless score tempid int = @s mot_uav_id run return run scoreboard players set right_slot_id int 0

# 发送姿态同步数据
scoreboard players set u int -2500
scoreboard players set v int 0
scoreboard players set w int 0
function math:uvw/_tovec
execute as @e[tag=mot_device] if score @s mot_uav_id = right_slot_id int run function module_control:_call_method {path:"_sync_coord"}
```

修改main函数，调用三个槽位的主程序

```
#mot_uav:main
# mot_uav:tick调用
# 实体对象主程序

...

# 外接设备
execute if score left_slot_id int matches 1.. run function mot_uav:left_slot/main
execute if score down_slot_id int matches 1.. run function mot_uav:down_slot/main
execute if score right_slot_id int matches 1.. run function mot_uav:right_slot/main

# 同步机翼电机开关
...
```

### 3.1.4 接入控制程序

创建控制程序program/left_connect

创建program/left_connect/.doc.mcfo

```
#mot_uav:program/left_connect/doc.mcfo

# 控制程序的临时对象
_this: {
	pointer: [storage mot_uav:io ptr,String],
	state: <state,int,1>
}
```

打开mot终端，创建program/left_connect/_proj, program/left_connect/_model, program/left_connect/_run

```
cre program/left_connect/_proj program/left_connect/_model program/left_connect/_run
```

![alt text](images/image-159.png)

实现program/left_connect/_proj, program/left_connect/_model

```
#mot_uav:program/left_connect/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score state int run data get storage mot_uav:io input.state
```

```
#mot_uav:program/left_connect/_model
# 使用临时对象构建数据模板
# 输出[storage mot_uav:io result]

data modify storage mot_uav:io result set value {pointer:"", state:0}

data modify storage mot_uav:io result.pointer set from storage mot_uav:io ptr
execute store result storage mot_uav:io result.state int 1 run scoreboard players get state int
```

实现program/left_connect/_run

```
#mot_uav:program/left_connect/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 提前返回
execute if score state int matches 2 run return fail

# 连接输入
scoreboard players operation inp int = tempid int
data modify storage mot_uav:io slot_type set value "left"

# 计算插槽坐标，向附近设备发送请求
scoreboard players set u int 2500
scoreboard players set v int 0
scoreboard players set w int 0
function math:uvw/_topos
scoreboard players set res int 0
execute at @s as @e[tag=mot_device,distance=..1] run function mot_uav:program/left_connect/check_request
scoreboard players operation inp int = res int

# 连接程序结束
scoreboard players set state int 2

# 确认连接
execute if score inp int matches 0 run return run tp @s 0 0 0
execute at @s run playsound minecraft:block.piston.contract player @a ~ ~ ~ 0.5 2.0
function mot_uav:left_slot/_connect

# 区块安全
tp @s 0 0 0
```

修改fans/main函数，获取tempid

```
#mot_uav:fans/main
# mot_uav:main调用

...

# 运行控制程序
execute if score temp_c int matches 1 run return fail
scoreboard players operation tempid int = @s mot_uav_id
execute if data storage mot_uav:io program.pointer as 0-0-0-0-0 run function mot_uav:fans/run_program with storage mot_uav:io program
```

打开mot终端，创建program/left_connect/check_request

```
cre program/left_connect/check_request
```

![alt text](images/image-160.png)

编写program/left_connect/check_request

```
#mot_uav:program/left_connect/check_request
# mot_uav:program/left_connect/_run调用

execute if score res int matches 1.. run return fail
function module_control:_call_method {path:"_sync_request"}
```

按同样的方式创建program/down_connect

```
#mot_uav:program/down_connect/doc.mcfo

# 控制程序的临时对象
_this: {
	pointer: [storage mot_uav:io ptr,String],
	state: <state,int,1>
}
```

```
cre program/down_connect/_proj program/down_connect/_model program/down_connect/_run program/down_connect/check_request
```

```
#mot_uav:program/down_connect/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score state int run data get storage mot_uav:io input.state
```

```
#mot_uav:program/down_connect/_model
# 使用临时对象构建数据模板
# 输出[storage mot_uav:io result]

data modify storage mot_uav:io result set value {pointer:"", state:0}

data modify storage mot_uav:io result.pointer set from storage mot_uav:io ptr
execute store result storage mot_uav:io result.state int 1 run scoreboard players get state int
```

```
#mot_uav:program/down_connect/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 提前返回
execute if score state int matches 2 run return fail

# 连接输入
scoreboard players operation inp int = tempid int
data modify storage mot_uav:io slot_type set value "down"

# 计算插槽坐标，向附近设备发送请求
scoreboard players set u int 0
scoreboard players set v int -2500
scoreboard players set w int 0
function math:uvw/_topos
scoreboard players set res int 0
execute at @s as @e[tag=mot_device,distance=..1] run function mot_uav:program/down_connect/check_request
scoreboard players operation inp int = res int

# 连接程序结束
scoreboard players set state int 2

# 确认连接
execute if score inp int matches 0 run return run tp @s 0 0 0
execute at @s run playsound minecraft:block.piston.contract player @a ~ ~ ~ 0.5 2.0
function mot_uav:down_slot/_connect

# 区块安全
tp @s 0 0 0
```

```
#mot_uav:program/down_connect/check_request
# mot_uav:program/down_connect/_run调用

execute if score res int matches 1.. run return fail
function module_control:_call_method {path:"_sync_request"}
```

按同样的方式创建program/right_connect

```
#mot_uav:program/right_connect/doc.mcfo

# 控制程序的临时对象
_this: {
	pointer: [storage mot_uav:io ptr,String],
	state: <state,int,1>
}
```

```
cre program/right_connect/_proj program/right_connect/_model program/right_connect/_run program/right_connect/check_request
```

```
#mot_uav:program/right_connect/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score state int run data get storage mot_uav:io input.state
```

```
#mot_uav:program/right_connect/_model
# 使用临时对象构建数据模板
# 输出[storage mot_uav:io result]

data modify storage mot_uav:io result set value {pointer:"", state:0}

data modify storage mot_uav:io result.pointer set from storage mot_uav:io ptr
execute store result storage mot_uav:io result.state int 1 run scoreboard players get state int
```

```
#mot_uav:program/right_connect/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 提前返回
execute if score state int matches 2 run return fail

# 连接输入
scoreboard players operation inp int = tempid int
data modify storage mot_uav:io slot_type set value "right"

# 计算插槽坐标，向附近设备发送请求
scoreboard players set u int -2500
scoreboard players set v int 0
scoreboard players set w int 0
function math:uvw/_topos
scoreboard players set res int 0
execute at @s as @e[tag=mot_device,distance=..1] run function mot_uav:program/right_connect/check_request
scoreboard players operation inp int = res int

# 连接程序结束
scoreboard players set state int 2

# 确认连接
execute if score inp int matches 0 run return run tp @s 0 0 0
execute at @s run playsound minecraft:block.piston.contract player @a ~ ~ ~ 0.5 2.0
function mot_uav:right_slot/_connect

# 区块安全
tp @s 0 0 0
```

```
#mot_uav:program/right_connect/check_request
# mot_uav:program/right_connect/_run调用

execute if score res int matches 1.. run return fail
function module_control:_call_method {path:"_sync_request"}
```

创建控制程序program/left_deconnect

.doc.mcfo, _proj, _model与left_connect相同

```
#mot_uav:program/left_deconnect/doc.mcfo

# 控制程序的临时对象
_this: {
	pointer: [storage mot_uav:io ptr,String],
	state: <state,int,1>
}
```

```
cre program/left_deconnect/_proj program/left_deconnect/_model program/left_deconnect/_run
```

```
#mot_uav:program/left_deconnect/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score state int run data get storage mot_uav:io input.state
```

```
#mot_uav:program/left_deconnect/_model
# 使用临时对象构建数据模板
# 输出[storage mot_uav:io result]

data modify storage mot_uav:io result set value {pointer:"", state:0}

data modify storage mot_uav:io result.pointer set from storage mot_uav:io ptr
execute store result storage mot_uav:io result.state int 1 run scoreboard players get state int
```

编写program/left_deconnect/_run，实现断开连接程序

```
#mot_uav:program/left_deconnect/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 提前返回
execute if score state int matches 2 run return fail

# 断开连接
function mot_uav:left_slot/_deconnect

# 播放音效
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get impulse_x int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players get impulse_y int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get impulse_z int
data modify entity @s Pos set from storage math:io xyz
execute at @s run playsound minecraft:block.piston.extend player @a ~ ~ ~ 0.5 2.0

# 区块安全
tp @s 0 0 0

# 连接程序结束
scoreboard players set state int 2
```

按同样的方式创建program/down_deconnect

```
#mot_uav:program/down_deconnect/doc.mcfo

# 控制程序的临时对象
_this: {
	pointer: [storage mot_uav:io ptr,String],
	state: <state,int,1>
}
```

```
cre program/down_deconnect/_proj program/down_deconnect/_model program/down_deconnect/_run
```

```
#mot_uav:program/down_deconnect/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score state int run data get storage mot_uav:io input.state
```

```
#mot_uav:program/down_deconnect/_model
# 使用临时对象构建数据模板
# 输出[storage mot_uav:io result]

data modify storage mot_uav:io result set value {pointer:"", state:0}

data modify storage mot_uav:io result.pointer set from storage mot_uav:io ptr
execute store result storage mot_uav:io result.state int 1 run scoreboard players get state int
```

```
#mot_uav:program/down_deconnect/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 提前返回
execute if score state int matches 2 run return fail

# 断开连接
function mot_uav:down_slot/_deconnect

# 播放音效
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get impulse_x int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players get impulse_y int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get impulse_z int
data modify entity @s Pos set from storage math:io xyz
execute at @s run playsound minecraft:block.piston.extend player @a ~ ~ ~ 0.5 2.0

# 区块安全
tp @s 0 0 0

# 连接程序结束
scoreboard players set state int 2
```

按同样的方式创建program/right_deconnect

```
#mot_uav:program/right_deconnect/doc.mcfo

# 控制程序的临时对象
_this: {
	pointer: [storage mot_uav:io ptr,String],
	state: <state,int,1>
}
```

```
cre program/right_deconnect/_proj program/right_deconnect/_model program/right_deconnect/_run
```

```
#mot_uav:program/right_deconnect/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score state int run data get storage mot_uav:io input.state
```

```
#mot_uav:program/right_deconnect/_model
# 使用临时对象构建数据模板
# 输出[storage mot_uav:io result]

data modify storage mot_uav:io result set value {pointer:"", state:0}

data modify storage mot_uav:io result.pointer set from storage mot_uav:io ptr
execute store result storage mot_uav:io result.state int 1 run scoreboard players get state int
```

```
#mot_uav:program/right_deconnect/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 提前返回
execute if score state int matches 2 run return fail

# 断开连接
function mot_uav:right_slot/_deconnect

# 播放音效
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get impulse_x int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players get impulse_y int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get impulse_z int
data modify entity @s Pos set from storage math:io xyz
execute at @s run playsound minecraft:block.piston.extend player @a ~ ~ ~ 0.5 2.0

# 区块安全
tp @s 0 0 0

# 连接程序结束
scoreboard players set state int 2
```

创建控制程序program/left_use

.doc.mcfo, _proj, _model与left_connect相同

```
#mot_uav:program/left_use/doc.mcfo

# 控制程序的临时对象
_this: {
	pointer: [storage mot_uav:io ptr,String],
	state: <state,int,1>
}
```

```
cre program/left_use/_proj program/left_use/_model program/left_use/_run
```

```
#mot_uav:program/left_use/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score state int run data get storage mot_uav:io input.state
```

```
#mot_uav:program/left_use/_model
# 使用临时对象构建数据模板
# 输出[storage mot_uav:io result]

data modify storage mot_uav:io result set value {pointer:"", state:0}

data modify storage mot_uav:io result.pointer set from storage mot_uav:io ptr
execute store result storage mot_uav:io result.state int 1 run scoreboard players get state int
```

```
#mot_uav:program/left_use/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 提前返回
execute if score state int matches 2 run return fail

# 设备使用中，则程序继续运行
scoreboard players set state int 1

# 向设备发送使用信号
scoreboard players set res int 1
execute as @e[tag=mot_device] if score @s mot_uav_id = left_slot_id int \
	run function module_control:_call_method {path:"_use_signal"}

# 设备是否使用结束
execute if score res int matches 1 run scoreboard players set state int 2
```

按同样的方式创建program/down_use

```
#mot_uav:program/down_use/doc.mcfo

# 控制程序的临时对象
_this: {
	pointer: [storage mot_uav:io ptr,String],
	state: <state,int,1>
}
```

```
cre program/down_use/_proj program/down_use/_model program/down_use/_run
```

```
#mot_uav:program/down_use/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score state int run data get storage mot_uav:io input.state
```

```
#mot_uav:program/down_use/_model
# 使用临时对象构建数据模板
# 输出[storage mot_uav:io result]

data modify storage mot_uav:io result set value {pointer:"", state:0}

data modify storage mot_uav:io result.pointer set from storage mot_uav:io ptr
execute store result storage mot_uav:io result.state int 1 run scoreboard players get state int
```

```
#mot_uav:program/down_use/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 提前返回
execute if score state int matches 2 run return fail

# 设备使用中，则程序继续运行
scoreboard players set state int 1

# 向设备发送使用信号
scoreboard players set res int 1
execute as @e[tag=mot_device] if score @s mot_uav_id = down_slot_id int \
	run function module_control:_call_method {path:"_use_signal"}

# 设备是否使用结束
execute if score res int matches 1 run scoreboard players set state int 2
```

按同样的方式创建program/right_use

```
#mot_uav:program/right_use/doc.mcfo

# 控制程序的临时对象
_this: {
	pointer: [storage mot_uav:io ptr,String],
	state: <state,int,1>
}
```

```
cre program/right_use/_proj program/right_use/_model program/right_use/_run
```

```
#mot_uav:program/right_use/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score state int run data get storage mot_uav:io input.state
```

```
#mot_uav:program/right_use/_model
# 使用临时对象构建数据模板
# 输出[storage mot_uav:io result]

data modify storage mot_uav:io result set value {pointer:"", state:0}

data modify storage mot_uav:io result.pointer set from storage mot_uav:io ptr
execute store result storage mot_uav:io result.state int 1 run scoreboard players get state int
```

```
#mot_uav:program/right_use/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 提前返回
execute if score state int matches 2 run return fail

# 设备使用中，则程序继续运行
scoreboard players set state int 1

# 向设备发送使用信号
scoreboard players set res int 1
execute as @e[tag=mot_device] if score @s mot_uav_id = right_slot_id int \
	run function module_control:_call_method {path:"_use_signal"}

# 设备是否使用结束
execute if score res int matches 1 run scoreboard players set state int 2
```

添加一个近着陆程序program/near_landing

实现直接照抄landing，只不过修改_run中的参数

```
#mot_uav:program/near_landing/doc.mcfo

# 高度控制程序的临时对象
_this: {
	pointer: [storage mot_uav:io ptr,String],
	state: <state,int,1>
}
```

```
cre program/near_landing/_proj program/near_landing/_model program/near_landing/_run
```

```
#mot_uav:program/near_landing/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score state int run data get storage mot_uav:io input.state
```

```
#mot_uav:program/near_landing/_model
# 使用临时对象构建数据模板
# 输出[storage mot_uav:io result]

data modify storage mot_uav:io result set value {pointer:"", state:0}

data modify storage mot_uav:io result.pointer set from storage mot_uav:io ptr
execute store result storage mot_uav:io result.state int 1 run scoreboard players get state int
```

```
#mot_uav:program/near_landing/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 计算target_y
scoreboard players operation vec_x int = x int
scoreboard players operation vec_y int = y int
scoreboard players operation vec_z int = z int
scoreboard players operation vec_y int -= mot_uav_ch int
scoreboard players operation vec_x int /= 10000 int
scoreboard players operation vec_y int /= 10000 int
scoreboard players operation vec_z int /= 10000 int
scoreboard players remove vec_y int 1
scoreboard players operation vec_x int *= 10000 int
scoreboard players operation vec_y int *= 10000 int
scoreboard players operation vec_z int *= 10000 int
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players add vec_x int 5000
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players add vec_y int 5000
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players add vec_z int 5000
data modify entity @s Pos set from storage math:io xyz
scoreboard players operation target_y int = vec_y int
execute at @s unless block ~ ~ ~ #mot_uav:pass run scoreboard players add target_y int 10000
scoreboard players operation target_y int += mot_uav_ch int

function mot_uav:program/landing/_model
data modify storage mot_uav:io temp set from storage mot_uav:io result

# 维持高度
data modify storage mot_uav:io input set from storage mot_uav:class default_programs[{id:"height"}]
execute store result storage mot_uav:io input.target_y double 0.0001 run scoreboard players get target_y int
function mot_uav:program/height/_proj
function mot_uav:program/height/_run
# 状态变量设置为height程序的状态
execute store result storage mot_uav:io temp.state int 1 run scoreboard players get state int

data modify storage mot_uav:io input set from storage mot_uav:io temp
function mot_uav:program/landing/_proj

# 区块安全
tp @s 0 0 0
```

我们修改program/forward，使其不仅能够前进，还能按照局部坐标位移

修改program/forward/.doc.mcfo

```
#mot_uav:program/forward/doc.mcfo

# 位移控制程序的临时对象
_this: {
	u:<u,int,1w>,
	v:<v,int,1w>,
	w:<w,int,1w>,
	pointer: [storage mot_uav:io ptr,String],
	target_y: <target_y,int,1w>,
	target_pos: {
		<target_x,int,1w>,
		<target_y,int,1w>,
		<target_z,int,1w>
	},
	damp_params: {
		<damp_k,int,1w>,
		<damp_b,int,1w>,
		<damp_f,int,1w>
	},
	state: <state,int,1>
}
```

修改program/forward/_proj, program/forward/_model

```
#mot_uav:program/forward/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

execute store result score u int run data get storage mot_uav:io input.u 10000
execute store result score v int run data get storage mot_uav:io input.v 10000
execute store result score w int run data get storage mot_uav:io input.w 10000
data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score target_y int run data get storage mot_uav:io input.target_y 10000
execute store result score target_x int run data get storage mot_uav:io input.target_pos[0] 10000
execute store result score target_z int run data get storage mot_uav:io input.target_pos[2] 10000
execute store result score damp_k int run data get storage mot_uav:io input.damp_params[0] 10000
execute store result score damp_b int run data get storage mot_uav:io input.damp_params[1] 10000
execute store result score damp_f int run data get storage mot_uav:io input.damp_params[2] 10000
execute store result score state int run data get storage mot_uav:io input.state
```

```
#mot_uav:program/forward/_model
# 使用临时对象构建数据模板
# 输出[storage mot_uav:io result]

data modify storage mot_uav:io result set value {u:0.0d, v:0.0d, w:0.0d, pointer:"", target_y:0.0d, target_pos:[0.0d,0.0d,0.0d], damp_params:[0.0d,0.0d,0.0d], state:0}

execute store result storage mot_uav:io result.u double 0.0001 run scoreboard players get u int
execute store result storage mot_uav:io result.v double 0.0001 run scoreboard players get v int
execute store result storage mot_uav:io result.w double 0.0001 run scoreboard players get w int
data modify storage mot_uav:io result.pointer set from storage mot_uav:io ptr
execute store result storage mot_uav:io result.target_y double 0.0001 run scoreboard players get target_y int
execute store result storage mot_uav:io result.target_pos[0] double 0.0001 run scoreboard players get target_x int
execute store result storage mot_uav:io result.target_pos[1] double 0.0001 run scoreboard players get target_y int
execute store result storage mot_uav:io result.target_pos[2] double 0.0001 run scoreboard players get target_z int
execute store result storage mot_uav:io result.damp_params[0] double 0.0001 run scoreboard players get damp_k int
execute store result storage mot_uav:io result.damp_params[1] double 0.0001 run scoreboard players get damp_b int
execute store result storage mot_uav:io result.damp_params[2] double 0.0001 run scoreboard players get damp_f int
execute store result storage mot_uav:io result.state int 1 run scoreboard players get state int
```

修改program/init/forward/_run

```
#mot_uav:program/forward/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

scoreboard players set state int 1

# 计算target_pos
function math:uvw/_tovec
scoreboard players operation target_x int = vec_x int
scoreboard players operation target_z int = vec_z int

# 转存为position程序
data modify storage mot_uav:io ptr set value "mot_uav:program/position"
```

添加一个不会终止的等待程序program/waiting

创建program/waiting/.doc.mcfo

```
#mot_uav:program/waiting/doc.mcfo

# 高度控制程序的临时对象
_this: {
	pointer: [storage mot_uav:io ptr,String],
	state: <state,int,1>,
	target_y: <target_y,int,1w>,
	wait_time: <wait_time,int,1>
}
```

创建program/waiting/_proj, program/waiting/_model, program/waiting/_run

```
cre program/waiting/_proj program/waiting/_model program/waiting/_run
```

编写program/waiting/_proj, program/waiting/_model, program/waiting/_run

```
#mot_uav:program/waiting/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score state int run data get storage mot_uav:io input.state
execute store result score target_y int run data get storage mot_uav:io input.target_y 10000
execute store result score wait_time int run data get storage mot_uav:io input.wait_time
```

```
#mot_uav:program/waiting/_model
# 使用临时对象构建数据模板
# 输出[storage mot_uav:io result]

data modify storage mot_uav:io result set value {pointer:"", state:0, target_y:0.0d}

data modify storage mot_uav:io result.pointer set from storage mot_uav:io ptr
execute store result storage mot_uav:io result.state int 1 run scoreboard players get state int
execute store result storage mot_uav:io result.target_y double 0.0001 run scoreboard players get target_y int
execute store result storage mot_uav:io result.wait_time int 1 run scoreboard players get wait_time int
```

```
#mot_uav:program/waiting/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

scoreboard players set state int 1
execute if score wait_time int matches 1.. run scoreboard players remove wait_time int 1
execute if score wait_time int matches 0 run scoreboard players set state int 2

function mot_uav:program/waiting/_model
data modify storage mot_uav:io temp set from storage mot_uav:io result

# 维持高度
data modify storage mot_uav:io input set from storage mot_uav:class default_programs[{id:"height"}]
execute store result storage mot_uav:io input.target_y double 0.0001 run scoreboard players get target_y int
function mot_uav:program/height/_proj
function mot_uav:program/height/_run

data modify storage mot_uav:io input set from storage mot_uav:io temp
function mot_uav:program/waiting/_proj
```

![alt text](images/image-176.png)

修改program/init，添加这些控制程序的模板

```
#mot_uav:program/init
# mot_uav:_init调用

# 预设控制程序的数据模板
data modify storage mot_uav:class default_programs set value [\
	{id:"waiting", pointer:"mot_uav:program/waiting", state:0, wait_time:-1},\
	{id:"landing", pointer:"mot_uav:program/landing", state:0},\
	{id:"near_landing", pointer:"mot_uav:program/near_landing", state:0},\
	{id:"left_connect", pointer:"mot_uav:program/left_connect", state:0},\
	{id:"left_deconnect", pointer:"mot_uav:program/left_deconnect", state:0},\
	{id:"left_use", pointer:"mot_uav:program/left_use", state:0},\
	{id:"down_connect", pointer:"mot_uav:program/down_connect", state:0},\
	{id:"down_deconnect", pointer:"mot_uav:program/down_deconnect", state:0},\
	{id:"down_use", pointer:"mot_uav:program/down_use", state:0},\
	{id:"right_connect", pointer:"mot_uav:program/right_connect", state:0},\
	{id:"right_deconnect", pointer:"mot_uav:program/right_deconnect", state:0},\
	{id:"right_use", pointer:"mot_uav:program/right_use", state:0},\
	{id:"height", pointer:"mot_uav:program/height", target_y:0.0d, damp_params:[0.95d,1.0d,0.008d], state:0},\
	{id:"rotation", pointer:"mot_uav:program/rotation", target_y:0.0d, target_theta:0.0d, damp_params:[0.0095d,0.01d,0.08d], state:0},\
	{id:"position", pointer:"mot_uav:program/position", target_y:0.0d, target_pos:[0.0d,0.0d,0.0d], damp_params:[0.95d,1.0d,0.008d], state:0},\
	{id:"up", pointer:"mot_uav:program/up", delta_y:0.0d, target_y:0.0d, damp_params:[0.95d,1.0d,0.008d], state:0},\
	{id:"turn", pointer:"mot_uav:program/turn", delta_theta:0.0d, target_y:0.0d, target_theta:0.0d, damp_params:[0.0095d,0.01d,0.08d], state:0},\
	{id:"forward", pointer:"mot_uav:program/forward", u:0.0d, v:0.0d, w:0.0d, target_y:0.0d, target_pos:[0.0d,0.0d,0.0d], damp_params:[0.95d,1.0d,0.008d], state:0}\
]
```

### 3.1.5 测试红石灯设备

接下来我们创建一个用于测试的设备模块mot_lamp

回到data目录，创建一个新的命名空间为mot_lamp

在mot_lamp内创建function文件夹

部署新的mot副本，放入.mot_memory, .mot.py, .doc.mcfo

**请注意.mot_memory不要复制mot_uav命名空间下已有的文件，因为这会继承白名单设置**

![alt text](images/image-161.png)

修改mot_lamp/function/.mot_memory/objects/global_settings

```
# 无需初始化/创建的数据位置
global_default: {
	positions: {
		<@s, x>, <@s, y>, <@s, z>,
		<@s, x, 1w>, <@s, y, 1w>, <@s, z, 1w>
	},
	caches: {
		[storage math:io xyz, ListDouble, 3],
		[storage math:io xyzw, ListFloat, 4],
		[storage math:io rec, ListCompound, 1],
		[storage math:io rotation, ListFloat, 2]
	}
}

# 整数常量
int_consts: {-1, 0, 1, 2, 3, 4, 5, 10, 100, 1000, 10000}

# 项目名称
project_name:mot_lamp

# 实体对象的数据位置
entity_store_path:item.components."minecraft:custom_data"

# 实体对象的类型
entity_type:item_display

# 初始化模块时创建的接口
init_interfaces:{
	_get,_store,_new,set,del,main,tick
}
```

编写.doc.mcfo，直接继承mot_uav中的运动属性，并添加mot_uav_root, slot_type属性

```
#mot_lamp:doc.mcfo

# 临时对象
_this:{
	slot_type:[storage mot_uav:io slot_type,String],
	mot_uav_root:<mot_uav_root,int>,
	static:<motion_static,int>,
	list_impulse:[storage mot_uav:io list_impulse,ListCompound],
	velocity:{<vx,int,1w>, <vy,int,1w>, <vz,int,1w>},
	angular_vec:{
		<angular_x,int,1w>,
		<angular_y,int,1w>,
		<angular_z,int,1w>
	},
	angular_len:<angular_len,int,1w>,
	position:{<x,int,1w>, <y,int,1w>, <z,int,1w>},
	uvw_coord:{
		ivec:{<ivec_x,int,1w>, <ivec_y,int,1w>, <ivec_z,int,1w>},
		jvec:{<jvec_x,int,1w>, <jvec_y,int,1w>, <jvec_z,int,1w>},
		kvec:{<kvec_x,int,1w>, <kvec_y,int,1w>, <kvec_z,int,1w>}
	},
	quaternion:{
		xyzw:{
			<quat_x,int,1w>,
			<quat_y,int,1w>,
			<quat_z,int,1w>,
			<quat_w,int,1w>
		},
		start_xyzw:{
			<quat_start_x,int,1w>,
			<quat_start_y,int,1w>,
			<quat_start_z,int,1w>,
			<quat_start_w,int,1w>
		},
		orth_xyzw:{
			<quat_orth_x,int,1w>,
			<quat_orth_y,int,1w>,
			<quat_orth_z,int,1w>,
			<quat_orth_w,int,1w>
		},
		phi:<quat_phi,int,1w>
	}
}
```

打开mot_lamp下的mot终端，输入初始化命令

```
init
```

创建_init接口

```
cre _init
```

输入回车同步代码

![alt text](images/image-162.png)

将_init, tick, main, _new, _del函数加入白名单

```
protect _init tick main _new _del
```

![alt text](images/image-163.png)

修改_new函数，构建mot_lamp的展示实体

```
#mot_lamp:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_lamp:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon item_display ~ ~ ~ {Tags:["mot_lamp", "result", "mot_device"],\
	item:{id:"minecraft:redstone",count:1b},\
	transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0f,0.0f,0.0f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f]},\
	CustomName:'"mot_lamp"',\
	teleport_duration:1, interpolation_duration:1,\
	Passengers:[\
		{id:"minecraft:block_display",Tags:["mot_lamp_display","lamp"],CustomName:'"mot_lamp_display"',block_state:{Name:"minecraft:redstone_lamp",Properties:{lit:"true"}},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.25f,0.25f,0.25f],left_rotation:[0f,0f,0f,1f],translation:[-0.125f,-0.125f,-0.125f]},interpolation_duration:1,brightness:{sky:15, block:15}}\
	]\
}
execute as @e[tag=result,limit=1] on passengers run function mot_uav:set_uvw
execute as @e[tag=result,limit=1] run function mot_lamp:set
execute as @e[tag=result,limit=1] run function mot_lamp:set_operations
```

为了方便辨认展示实体属于哪个模块，我们为mot_lamp的展示实体设置了CustomName属性

这里同样设置一下mot_uav:_new中的CustomName

```
#mot_uav:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_uav:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon item_display ~ ~ ~ {Tags:["mot_uav", "result", "mot_device"],\
	item:{id:"minecraft:observer", count:1b},\
	transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f]},\
	CustomName:'"mot_uav"',\
	teleport_duration:1, interpolation_duration:1,\
	Passengers:[\
		{id:"minecraft:block_display",Tags:["mot_uav_display","torch"],CustomName:'"mot_uav_torch"',block_state:{Name:"minecraft:redstone_torch",Properties:{lit:"true"}},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],translation:[-0.25f,0.25f,-0.25f]},interpolation_duration:1,brightness:{sky:15, block:15}},\
		{id:"minecraft:item_display",Tags:["mot_uav_display","fan_0","fan","local_quat"],CustomName:'"mot_uav_fan_0"',item:{id:"minecraft:heavy_weighted_pressure_plate",count:1b},transformation:{right_rotation:[0f,0.3826f,0f,0.9238f],scale:[0.2f,0.5f,1.2f],left_rotation:[0f,0f,0f,1f],translation:[0f,0.6f,0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_uav_display","fan_1","fan","local_quat"],CustomName:'"mot_uav_fan_1"',item:{id:"minecraft:heavy_weighted_pressure_plate",count:1b},transformation:{right_rotation:[0f,0.3826f,0f,0.9238f],scale:[1.2f,0.5f,0.2f],left_rotation:[0f,0f,0f,1f],translation:[0f,0.6f,0f]},interpolation_duration:1},\
	]\
}
execute as @e[tag=result,limit=1] on passengers run function mot_uav:set_uvw
execute as @e[tag=result,limit=1] run function mot_uav:set
execute as @e[tag=result,limit=1] run function mot_uav:set_operations
```

为了解决编号超过2147483647的问题，我们给mot_uav_id引入统一的编号池机制

同时完成mot_uav模块的注册

修改mot_uav:_class

```
#mot_uav:_class
# 生成预设静态数据模板

# 生成测试数据模板
function mot_uav:_zero
execute positioned 8 -56 8 rotated 0.0 0.0 as @e[tag=math_marker,limit=1] run function mot_uav:_anchor_to
function mot_uav:_model
data modify storage mot_uav:class test set from storage mot_uav:io result

# 无人机计数器
scoreboard objectives add mot_uav_id dummy
scoreboard players set #id mot_uav_id 0

# 编号池
data modify storage mot_uav:io free_addr set value []

# 初始化模块控制
scoreboard objectives add int dummy
execute unless score module_control_inited int matches 1 run function module_control:_init

# 注册本模块
data modify storage module_control:io input set value {prefix:"mot_uav:",namespace:"mot_uav"}
function module_control:data/_reg
scoreboard players operation #mot_uav: module_id = res int
```

打开mot_uav下的mot终端，创建_new_id, new_addr

```
cre _new_id new_addr
```

![alt text](images/image-164.png)

编写mot_uav:_new_id

```
#mot_uav:_new_id
# 分配编号
# 输出<res,int>

execute unless data storage mot_uav:io free_addr[0] run function mot_uav:new_addr
execute store result score res int run data get storage mot_uav:io free_addr[0]
data remove storage mot_uav:io free_addr[0]
```

编写mot_uav:new_addr

```
#mot_uav:new_addr
# mot_uav:_new_id调用

data modify storage mot_uav:io free_addr prepend value 0
execute store result storage mot_uav:io free_addr[0] int 1 run scoreboard players add #id mot_uav_id 1
```

修改mot_uav:set_operations中获取编号的方式

同时获取模块编号

```
#mot_uav:set_operations
# mot_uav:_new调用

# 同步机翼电机开关
function mot_uav:fans/update_torch

# 初始化本地四元数
execute on passengers if entity @s[tag=local_quat] run scoreboard players set @s iquat_w 10000

# 获取无人机编号
function mot_uav:_new_id
scoreboard players operation @s mot_uav_id = res int

# 获取模块编号
scoreboard players operation @s module_id = #mot_uav: module_id

# 初始化为iframe_box对象
function iframe:box/_prescript
```

修改mot_uav:_del，释放编号

```
#mot_uav:_del
# 销毁实体对象
# 输入执行实体

data modify storage mot_uav:io free_addr prepend value 0
execute store result storage mot_uav:io free_addr[0] int 1 run scoreboard players get @s mot_uav_id

execute on passengers run kill @s
kill @s
```

修改mot_lamp:_del，改变设备实例销毁方式

```
#mot_lamp:_del
# 销毁实例

data modify storage mot_uav:io free_addr prepend value 0
execute store result storage mot_uav:io free_addr[0] int 1 run scoreboard players get @s mot_uav_id

execute on passengers run kill @s
kill @s
```

修改mot_lamp:_init，注册该模块

```
#mot_lamp:_init
# 初始化mot_lamp包

# 初始化模块控制
scoreboard objectives add int dummy
execute unless score module_control_inited int matches 1 run function module_control:_init

# 注册本模块
data modify storage module_control:io input set value {prefix:"mot_lamp:",namespace:"mot_lamp"}
function module_control:data/_reg
scoreboard players operation #mot_lamp: module_id = res int

# 添加记分板
scoreboard objectives add mot_uav_root dummy

# 设置常量
function mot_lamp:_consts

# 设置静态模板
function mot_lamp:_class
```

打开mot_lamp下的mot终端，创建set_operations

```
cre set_operations
```

![alt text](images/image-165.png)

编写mot_lamp:set_operations

```
#mot_lamp:set_operations
# mot_lamp:_new调用

# 进入关闭状态
function mot_lamp:_off

# 获取设备编号
function mot_uav:_new_id
scoreboard players operation @s mot_uav_id = res int

# 获取模块编号
scoreboard players operation @s module_id = #mot_lamp: module_id
```

打开mot_lamp下的mot终端，创建_on, _off

```
cre _on _off
```

![alt text](images/image-166.png)

编写mot_lamp:_on, mot_lamp:_off

```
#mot_lamp:_on
# 打开红石灯
# 以设备实例为执行者

execute on passengers run data modify entity @s brightness set value {sky:15, block:15}
execute on passengers run data modify entity @s block_state.Properties.lit set value "true"

execute at @s run playsound minecraft:block.lever.click player @a ~ ~ ~ 0.5 0.5
```

```
#mot_lamp:_off
# 关闭红石灯
# 以设备实例为执行者

execute on passengers run data remove entity @s brightness
execute on passengers run data modify entity @s block_state.Properties.lit set value "false"

execute at @s run playsound minecraft:block.lever.click player @a ~ ~ ~ 0.5 0.5
```

我们在mot_uav中以同样的方式控制红石信号火把的亮灭

修改mot_uav:fans/update_torch

```
#mot_uav:fans/update_torch
# mot_uav:fans/_on调用
# mot_uav:fans/_off调用
# mot_uav:fans/_update调用
# mot_uav:set_operations调用

data modify storage mot_uav:io temp set value "false"
execute if score @s fans_power matches 1.. run data modify storage mot_uav:io temp set value "true"

execute on passengers if entity @s[tag=torch] run \
	data modify entity @s block_state.Properties.lit set from storage mot_uav:io temp

execute if data storage mot_uav:io {temp:"true"} on passengers if entity @s[tag=torch] run \
	data modify entity @s brightness set value {sky:15, block:15}

execute if data storage mot_uav:io {temp:"false"} on passengers if entity @s[tag=torch] run \
	data remove entity @s brightness

execute if score @s fans_power matches 0 run data modify entity @s item.components."minecraft:custom_data".program.state set value 0
```

打开mot_lamp下的mot终端，创建collision/_load_data

```
cre collision/_load_data
```

![alt text](images/image-167.png)

编写collision/_load_data

```
#mot_lamp:collision/_load_data
# 加载红石灯碰撞数据

# 着陆底盘距离
scoreboard players set mot_uav_ch int 1250

# 碰撞点列表
data modify storage mot_uav:io collision_points set value [\
	[-0.125d, -0.125d, -0.125d],\
	[-0.125d, -0.125d, 0.125d],\
	[-0.125d, 0.125d, -0.125d],\
	[-0.125d, 0.125d, 0.125d],\
	[0.125d, -0.125d, -0.125d],\
	[0.125d, -0.125d, 0.125d],\
	[0.125d, 0.125d, -0.125d],\
	[0.125d, 0.125d, 0.125d]\
]

# 是否加载完成
return 1
```

修改mot_lamp:tick

```
#mot_lamp:tick

execute if entity @e[tag=mot_lamp,limit=1] if function mot_lamp:collision/_load_data as @e[tag=mot_lamp] run function mot_lamp:main
```

修改mot_lamp:main

```
#mot_lamp:main
# mot_lamp:tick调用
# 实体对象主程序

function mot_lamp:_get

scoreboard players operation tempid int = @s mot_uav_root
execute if score tempid int matches 0 run function mot_uav:device/_main_motion
execute if score tempid int matches 1.. if function mot_lamp:sync_uvw run function mot_uav:device/_main_sync

function mot_lamp:_store

# 坐标安全
execute unless score y int matches -640000..5120000 run function mot_uav:_del
```

打开mot_lamp下的mot终端，创建sync_uvw

```
cre sync_uvw
```

![alt text](images/image-168.png)

编写sync_uvw

```
#mot_lamp:sync_uvw
# mot_lamp:main调用

scoreboard players set mot_sync_u int 0
scoreboard players set mot_sync_v int 0
scoreboard players set mot_sync_w int 0

execute if data storage mot_uav:io {slot_type:"left"} run scoreboard players set mot_sync_u int -1250
execute if data storage mot_uav:io {slot_type:"down"} run scoreboard players set mot_sync_v int 1250
execute if data storage mot_uav:io {slot_type:"right"} run scoreboard players set mot_sync_u int 1250

# 设置完成
return 1
```

打开mot_lamp下的mot终端，创建协议要求的接口_sync_request, _sync_coord, _use_signal

```
cre _sync_request _sync_coord _use_signal
```

![alt text](images/image-169.png)

_sync_coord, _sync_request均采用默认实现

```
#mot_lamp:_sync_request

function mot_uav:device/_sync_request
```

```
#mot_lamp:_sync_coord

function mot_uav:device/_sync_coord
```

实现_use_signal接口

```
#mot_lamp:_use_signal
# 接收使用信号
# 输出<res,int>, 使用结束?1:0

# 改变红石灯状态
execute on passengers run data modify storage mot_lamp:io lit set from entity @s block_state.Properties.lit
execute if data storage mot_lamp:io {lit:"true"} run function mot_lamp:_off
execute if data storage mot_lamp:io {lit:"false"} run function mot_lamp:_on

# 单次触发直接结束
scoreboard players set res int 1
```

打开mot_lamp下的mot终端，创建_class, _zero, _model, _anchor_to接口

```
cre _class _zero _model _anchor_to
```

输入回车同步代码

将_class接口加入白名单

```
protect _class
```

![alt text](images/image-170.png)

_anchor_to接口直接照抄mot_uav实现

```
#mot_lamp:_anchor_to
# 输入执行坐标
# 输入执行朝向
# 需要传入世界实体为执行者

tp @s ~ ~ ~
data modify storage math:io xyz set from entity @s Pos
execute store result score x int run data get storage math:io xyz[0] 10000
execute store result score y int run data get storage math:io xyz[1] 10000
execute store result score z int run data get storage math:io xyz[2] 10000

function math:quat/_facing_to
function math:quat/_touvw

# 更新四元数旋转参数
function mot_uav:angular/_update
```

编写_class接口

```
#mot_lamp:_class
# 生成预设静态数据模板

# 生成测试数据模板
function mot_lamp:_zero
execute positioned 8 -59 8 rotated 0.0 0.0 as @e[tag=math_marker,limit=1] run function mot_lamp:_anchor_to
function mot_lamp:_model
data modify storage mot_lamp:class test set from storage mot_lamp:io result
```

打开mot_lamp下的mot终端，创建一个异步测试项目命名为display

```
creisp test/display/start
```

![alt text](images/image-171.png)

修改test/display/start

```
#mot_lamp:test/display/start

# 生成测试程序实体
tag @e[tag=result] remove result
data modify storage mot_lamp:io input set from storage mot_lamp:class test
function mot_lamp:_new

...

# 设置测试程序运行时间
scoreboard players set @e[tag=result,limit=1] killtime 200
```

```
#mot_lamp:test/display/end

function mot_lamp:_del
```

进入游戏运行测试

```
reload
function mot_uav:_init
function mot_lamp:_init
```

放置一个循环命令方块运行mot_lamp:tick

```
function mot_lamp:tick
```

![alt text](images/image-172.png)

聊天栏继续运行

```
scoreboard players set test int 1
function mot_lamp:test/display/start
```

![alt text](images/image-173.png)

红石灯落地

接下来测试设备连接功能

我们回到mot_uav命名空间

打开mot_uav下的mot终端，创建异步测试项目命名为device_sync

```
creisp test/device_sync/start
```

![alt text](images/image-174.png)

修改test/device_sync/start

额外生成mot_lamp作为测试设备，并调用test/program/main作为本测试主程序

```
#mot_uav:test/device_sync/start

# 生成测试程序实体
function mot_lamp:_init
data modify storage mot_lamp:io input set from storage mot_lamp:class test
function mot_lamp:_new
tag @e[tag=result,limit=1] add test_device
data modify storage mot_uav:io input set from storage mot_uav:class test
function mot_uav:_new

execute as @e[tag=result,limit=1] run function marker_control:data/_get

# 控制程序管线
data modify storage marker_control:io result.lst_programs set value []
# 上升1格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"up"}]
data modify storage marker_control:io result.lst_programs[-1].delta_y set value 1.0d
# 降落近地面
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"near_landing"}]
# 连接设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"down_connect"}]
# 上升3格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"up"}]
data modify storage marker_control:io result.lst_programs[-1].delta_y set value 3.0d
# 打开设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"down_use"}]
# 前进5格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"forward"}]
data modify storage marker_control:io result.lst_programs[-1].w set value 5.0d
data remove storage marker_control:io result.lst_programs[-1].target_y
# 关闭设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"down_use"}]
# 降落近地面
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"near_landing"}]
# 断开设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"down_deconnect"}]
# 右偏0.5格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"forward"}]
data modify storage marker_control:io result.lst_programs[-1].u set value -0.5d
data remove storage marker_control:io result.lst_programs[-1].target_y
# 连接设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"left_connect"}]
# 等待1秒
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"waiting"}]
data modify storage marker_control:io result.lst_programs[-1].wait_time set value 20
# 打开设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"left_use"}]
# 等待1秒
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"waiting"}]
data modify storage marker_control:io result.lst_programs[-1].wait_time set value 20
# 关闭设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"left_use"}]
# 等待1秒
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"waiting"}]
data modify storage marker_control:io result.lst_programs[-1].wait_time set value 20
# 断开设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"left_deconnect"}]
# 左偏1格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"forward"}]
data modify storage marker_control:io result.lst_programs[-1].u set value 1.0d
data remove storage marker_control:io result.lst_programs[-1].target_y
# 连接设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"right_connect"}]
# 等待1秒
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"waiting"}]
data modify storage marker_control:io result.lst_programs[-1].wait_time set value 20
# 打开设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"right_use"}]
# 等待1秒
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"waiting"}]
data modify storage marker_control:io result.lst_programs[-1].wait_time set value 20
# 关闭设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"right_use"}]
# 等待1秒
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"waiting"}]
data modify storage marker_control:io result.lst_programs[-1].wait_time set value 20
# 断开设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"right_deconnect"}]
# 等待1秒
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"waiting"}]
data modify storage marker_control:io result.lst_programs[-1].wait_time set value 20
# 结束测试
data modify storage marker_control:io result.lst_programs append value {}

# 设置测试程序主函数和销毁函数
data modify storage marker_control:io result.tick_func set value "mot_uav:test/program/main"
data modify storage marker_control:io result.del_func set value "mot_uav:test/device_sync/end"

execute as @e[tag=result,limit=1] run function marker_control:data/_store
tag @e[tag=result,limit=1] add entity_ticked
tag @e[tag=result,limit=1] add entity_todel

# 设置测试程序运行时间
scoreboard players set @e[tag=result,limit=1] killtime 500

scoreboard players set n int 1
```

修改test/device_sync/end，销毁所有测试实例

```
#mot_uav:test/device_sync/end

execute as @e[tag=test_device] run function module_control:_call_method {path:"_del"}
function mot_uav:_del
```

进入游戏运行测试

```
reload
function mot_uav:test/device_sync/start
```

![alt text](images/image-178.png)

观察到无人机完成了所有动作

### 3.1.6 接入GUI系统

接下来我们为无人机的GUI添加外接设备按钮

修改guis/entered/items，填充GUI物品

```
#mot_uav:guis/entered/items

...

item replace entity @s hotbar.4 with heavy_weighted_pressure_plate[minecraft:custom_data={iframe_ui:1b,button:4b},minecraft:custom_name='{"text":"left_device","color":"red"}']
item replace entity @s hotbar.5 with heavy_weighted_pressure_plate[minecraft:custom_data={iframe_ui:1b,button:5b},minecraft:custom_name='{"text":"down_device","color":"red"}']
item replace entity @s hotbar.6 with heavy_weighted_pressure_plate[minecraft:custom_data={iframe_ui:1b,button:6b},minecraft:custom_name='{"text":"right_device","color":"red"}']
```

修改guis/entered/main，实现按钮逻辑

```
#mot_uav:guis/entered/main

...

# 检测GUI发生变动
scoreboard players set update_gui int 0

execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:0b} run function mot_uav:guis/entered/s_up_down
execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:1b} run function mot_uav:guis/entered/s_clockwise
execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:2b} run scoreboard players set update_gui int 1
execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:3b} run function mot_uav:guis/entered/button_3
execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:4b} run function mot_uav:guis/entered/left_q
execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:5b} run function mot_uav:guis/entered/down_q
execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:6b} run function mot_uav:guis/entered/right_q
execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:7b} run function mot_uav:guis/entered/s_on_off
execute unless data storage iframe:io inv[].components."minecraft:custom_data"{button:8b} run return run function mot_uav:guis/entered/exit

execute if data storage iframe:io inv[{Slot:-106b}].components."minecraft:custom_data"{button:0b} run function mot_uav:guis/entered/button_0
execute if data storage iframe:io inv[{Slot:-106b}].components."minecraft:custom_data"{button:1b} run function mot_uav:guis/entered/button_1
execute if data storage iframe:io inv[{Slot:-106b}].components."minecraft:custom_data"{button:2b} run function mot_uav:guis/entered/button_2
execute if data storage iframe:io inv[{Slot:-106b}].components."minecraft:custom_data"{button:4b} run function mot_uav:guis/entered/button_4
execute if data storage iframe:io inv[{Slot:-106b}].components."minecraft:custom_data"{button:5b} run function mot_uav:guis/entered/button_5
execute if data storage iframe:io inv[{Slot:-106b}].components."minecraft:custom_data"{button:6b} run function mot_uav:guis/entered/button_6

execute if score update_gui int matches 1 run function mot_uav:guis/entered/items
```

请注意我们调换了F键检测与刷新物品栏的顺序

这是因为我们希望，在F键触发的函数中，也能通过将update_gui置1来实现单次触发

打开mot_uav下的mot终端，创建按钮函数

```
cre guis/entered/left_q guis/entered/down_q guis/entered/right_q guis/entered/button_4 guis/entered/button_5 guis/entered/button_6
```

![alt text](images/image-179.png)

实现guis/entered/left_q, guis/entered/down_q, guis/entered/right_q中的装卸逻辑

```
#mot_uav:guis/entered/left_q

# 获取无人机
execute store result score tempid int run data get storage iframe:io result.mot_uav_id
scoreboard players set res int 0
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run tag @s add tmp

# 根据left_slot状态上传程序
execute as @e[tag=tmp,limit=1] run function mot_uav:_get
execute if score left_slot_id int matches 0 run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"left_connect"}]
execute if score left_slot_id int matches 1.. run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"left_deconnect"}]
execute as @e[tag=tmp,limit=1] run function mot_uav:_store

tag @e[tag=tmp] remove tmp

scoreboard players set update_gui int 1
```

```
#mot_uav:guis/entered/down_q

# 获取无人机
execute store result score tempid int run data get storage iframe:io result.mot_uav_id
scoreboard players set res int 0
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run tag @s add tmp

# 根据down_slot状态上传程序
execute as @e[tag=tmp,limit=1] run function mot_uav:_get
execute if score down_slot_id int matches 0 run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"down_connect"}]
execute if score down_slot_id int matches 1.. run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"down_deconnect"}]
execute as @e[tag=tmp,limit=1] run function mot_uav:_store

tag @e[tag=tmp] remove tmp

scoreboard players set update_gui int 1
```

```
#mot_uav:guis/entered/right_q

# 获取无人机
execute store result score tempid int run data get storage iframe:io result.mot_uav_id
scoreboard players set res int 0
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run tag @s add tmp

# 根据right_slot状态上传程序
execute as @e[tag=tmp,limit=1] run function mot_uav:_get
execute if score right_slot_id int matches 0 run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"right_connect"}]
execute if score right_slot_id int matches 1.. run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"right_deconnect"}]
execute as @e[tag=tmp,limit=1] run function mot_uav:_store

tag @e[tag=tmp] remove tmp

scoreboard players set update_gui int 1
```

实现guis/entered/button_4, guis/entered/button_5, guis/entered/button_6

```
#mot_uav:guis/entered/button_4

# 获取左插槽设备
execute store result score tempid int run data get storage iframe:io result.mot_uav_id
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run scoreboard players operation tempid int = @s left_slot_id
execute as @e[tag=mot_device] if score @s mot_uav_id = tempid int run tag @s add tmp
execute unless entity @e[tag=tmp,limit=1] run return run scoreboard players set update_gui int 1

scoreboard players set res int 1
execute as @e[tag=tmp,limit=1] run function module_control:_call_method {path:"_use_signal"}
execute if score res int matches 1 run scoreboard players set update_gui int 1

tag @e[tag=tmp] remove tmp
```

```
#mot_uav:guis/entered/button_5

# 获取左插槽设备
execute store result score tempid int run data get storage iframe:io result.mot_uav_id
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run scoreboard players operation tempid int = @s down_slot_id
execute as @e[tag=mot_device] if score @s mot_uav_id = tempid int run tag @s add tmp
execute unless entity @e[tag=tmp,limit=1] run return run scoreboard players set update_gui int 1

scoreboard players set res int 1
execute as @e[tag=tmp,limit=1] run function module_control:_call_method {path:"_use_signal"}
execute if score res int matches 1 run scoreboard players set update_gui int 1

tag @e[tag=tmp] remove tmp
```

```
#mot_uav:guis/entered/button_6

# 获取左插槽设备
execute store result score tempid int run data get storage iframe:io result.mot_uav_id
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run scoreboard players operation tempid int = @s right_slot_id
execute as @e[tag=mot_device] if score @s mot_uav_id = tempid int run tag @s add tmp
execute unless entity @e[tag=tmp,limit=1] run return run scoreboard players set update_gui int 1

scoreboard players set res int 1
execute as @e[tag=tmp,limit=1] run function module_control:_call_method {path:"_use_signal"}
execute if score res int matches 1 run scoreboard players set update_gui int 1

tag @e[tag=tmp] remove tmp
```

进入游戏运行测试

```
reload
function mot_uav:test/general/start
execute as @e[tag=test,limit=1] run function mot_uav:_controller
```

生成测试红石灯

```
function mot_lamp:test/display/start
```

![alt text](images/image-180.png)

通过GUI操作无人机，成功完成了设备的装卸与使用

值得注意的是，由于我们采用了这样的设计：

无人机与外接设备只负责它们自己的连接信号，与外部是解耦的

因此当外部出现意外情况时，例如mot_lamp的display测试时间结束，自行消失

无人机的连接也会自动断开，系统运行正常

## 第二节：添加外接设备

### 3.2.1 添加机枪设备

回到data目录，创建新的命名空间mot_scatter

在mot_scatter/function下部署新的mot副本

**请注意.mot_memory不要复制已有模块下的文件，因为这会继承白名单设置**

![alt text](images_part2/image.png)

修改.mot_memory/objects/global_settings.mcfo

```
# 无需初始化/创建的数据位置
global_default: {
	positions: {
		<@s, x>, <@s, y>, <@s, z>,
		<@s, x, 1w>, <@s, y, 1w>, <@s, z, 1w>
	},
	caches: {
		[storage math:io xyz, ListDouble, 3],
		[storage math:io xyzw, ListFloat, 4],
		[storage math:io rec, ListCompound, 1],
		[storage math:io rotation, ListFloat, 2]
	}
}

# 整数常量
int_consts: {-1, 0, 1, 2, 3, 4, 5, 10, 100, 1000, 10000}

# 项目名称
project_name:mot_scatter

# 实体对象的数据位置
entity_store_path:item.components."minecraft:custom_data"

# 实体对象的类型
entity_type:item_display

# 初始化模块时创建的接口
init_interfaces:{
	_get,_store,_new,set,_del,main,tick
}
```

编写.doc.mcfo

```
#mot_scatter:doc.mcfo

# 临时对象
_this:{
	scatter_phi:<scatter_phi,int,1w>,
	bullet_res:<bullet_res,int>,
	slot_type:[storage mot_uav:io slot_type,String],
	mot_uav_root:<mot_uav_root,int>,
	static:<motion_static,int>,
	list_impulse:[storage mot_uav:io list_impulse,ListCompound],
	velocity:{<vx,int,1w>, <vy,int,1w>, <vz,int,1w>},
	angular_vec:{
		<angular_x,int,1w>,
		<angular_y,int,1w>,
		<angular_z,int,1w>
	},
	angular_len:<angular_len,int,1w>,
	position:{<x,int,1w>, <y,int,1w>, <z,int,1w>},
	uvw_coord:{
		ivec:{<ivec_x,int,1w>, <ivec_y,int,1w>, <ivec_z,int,1w>},
		jvec:{<jvec_x,int,1w>, <jvec_y,int,1w>, <jvec_z,int,1w>},
		kvec:{<kvec_x,int,1w>, <kvec_y,int,1w>, <kvec_z,int,1w>}
	},
	quaternion:{
		xyzw:{
			<quat_x,int,1w>,
			<quat_y,int,1w>,
			<quat_z,int,1w>,
			<quat_w,int,1w>
		},
		start_xyzw:{
			<quat_start_x,int,1w>,
			<quat_start_y,int,1w>,
			<quat_start_z,int,1w>,
			<quat_start_w,int,1w>
		},
		orth_xyzw:{
			<quat_orth_x,int,1w>,
			<quat_orth_y,int,1w>,
			<quat_orth_z,int,1w>,
			<quat_orth_w,int,1w>
		},
		phi:<quat_phi,int,1w>
	}
}
```

打开mot_scatter下的mot终端，输入init命令，创建_init函数，初始化代码，并完成白名单设置

```
init
cre _init
sync
protect _init tick main _new _class _del
```

修改_init函数，完成模块注册

```
#mot_scatter:_init
# 初始化mot_scatter包

# 初始化模块控制
scoreboard objectives add int dummy
execute unless score module_control_inited int matches 1 run function module_control:_init

# 注册本模块
data modify storage module_control:io input set value {prefix:"mot_scatter:",namespace:"mot_scatter"}
function module_control:data/_reg
scoreboard players operation #mot_scatter: module_id = res int

# 建立记分板
scoreboard objectives add scatter_phi dummy
scoreboard objectives add bullet_res dummy
scoreboard objectives add mot_uav_root dummy

# 设置常量
function mot_scatter:_consts

# 生成静态数据模板
function mot_scatter:_class
```

打开mot_scatter下的mot终端，创建collision/_load_data

```
cre collision/_load_data
```

编写collision/_load_data

```
#mot_scatter:collision/_load_data
# 加载机枪碰撞数据

# 碰撞点列表
data modify storage mot_uav:io collision_points set value [\
	[-0.125d, -0.125d, -0.125d],\
	[-0.125d, -0.125d, 0.125d],\
	[-0.125d, 0.125d, -0.125d],\
	[-0.125d, 0.125d, 0.125d],\
	[0.125d, -0.125d, -0.125d],\
	[0.125d, -0.125d, 0.125d],\
	[0.125d, 0.125d, -0.125d],\
	[0.125d, 0.125d, 0.125d]\
]

# 是否加载完成
return 1
```

修改tick函数

```
#mot_scatter:tick

execute if entity @e[tag=mot_scatter,limit=1] if function mot_scatter:collision/_load_data as @e[tag=mot_scatter] run function mot_scatter:main
```

修改_del函数

```
#mot_scatter:_del
# 销毁实体对象
# 输入执行实体

data modify storage mot_uav:io free_addr prepend value 0
execute store result storage mot_uav:io free_addr[0] int 1 run scoreboard players get @s mot_uav_id

execute on passengers run kill @s
kill @s
```

修改_new函数

```
#mot_scatter:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_scatter:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon item_display ~ ~ ~ {Tags:["mot_scatter", "result", "mot_device"],\
	item:{id:"minecraft:piston", count:1b},\
	transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.25f,0.25f,0.25f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f]},\
	CustomName:'"mot_scatter"',\
	teleport_duration:1, interpolation_duration:1,\
	Passengers:[\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_0","barrel","local_quat"],CustomName:'"mot_scatter_barrel_0"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.2f,0.5f,0.2f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_1","barrel","local_quat"],CustomName:'"mot_scatter_barrel_1"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.2f,0.5f,0.2f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_2","barrel","local_quat"],CustomName:'"mot_scatter_barrel_2"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.2f,0.5f,0.2f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_3","barrel","local_quat"],CustomName:'"mot_scatter_barrel_3"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.2f,0.5f,0.2f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_4","barrel","local_quat"],CustomName:'"mot_scatter_barrel_4"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.2f,0.5f,0.2f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_5","barrel","local_quat"],CustomName:'"mot_scatter_barrel_5"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.2f,0.5f,0.2f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
	]\
}
execute as @e[tag=result,limit=1] on passengers run function mot_uav:set_uvw
execute as @e[tag=result,limit=1] run function mot_scatter:set
execute as @e[tag=result,limit=1] run function mot_scatter:set_operations
```

打开mot_scatter下的mot终端，创建set_operations

```
cre set_operations
```

编写set_operations

```
#mot_scatter:set_operations
# mot_scatter:_new调用

# 初始化枪管相位角
scoreboard players set temp_phi int -600000
execute on passengers store result score @s scatter_phi run scoreboard players add temp_phi int 600000

# 更新枪管状态
function mot_scatter:update_barrel

# 获取设备编号
function mot_uav:_new_id
scoreboard players operation @s mot_uav_id = res int

# 获取模块编号
scoreboard players operation @s module_id = #mot_scatter: module_id
```

创建update_barrel

```
cre update_barrel
```

编写update_barrel

```
#mot_scatter:update_barrel
# mot_scatter:set_operations调用
# mot_scatter:main调用

scoreboard players operation temp_phi int = @s scatter_phi
execute on passengers run function mot_scatter:update_barrel_phi
```

创建update_barrel_phi

```
cre update_barrel_phi
```

编写update_barrel_phi

```
#mot_scatter:update_barrel_phi
# mot_scatter:update_barrel调用

# 计算本地四元数
scoreboard players operation psi int = temp_phi int
scoreboard players operation psi int += @s scatter_phi
execute as 0-0-0-0-0 run function math:iquat/_psi_to
function math:iquat/_store

# 计算局部坐标
scoreboard players operation @s u = iquat_w int
scoreboard players operation @s v = iquat_z int
scoreboard players operation @s u /= 10 int
scoreboard players operation @s v /= 10 int
```

打开mot_scatter下的mot终端，创建接口_class, _anchor_to, _zero, _model

然后创建一个异步测试项目命名为display

```
cre _class _anchor_to _zero _model
creisp test/display/start
```

实现_anchor_to接口，直接参照mot_uav:_anchor_to

```
#mot_scatter:_anchor_to
# 输入执行坐标
# 输入执行朝向
# 需要传入世界实体为执行者

tp @s ~ ~ ~
data modify storage math:io xyz set from entity @s Pos
execute store result score x int run data get storage math:io xyz[0] 10000
execute store result score y int run data get storage math:io xyz[1] 10000
execute store result score z int run data get storage math:io xyz[2] 10000

function math:quat/_facing_to
function math:quat/_touvw

# 更新四元数旋转参数
function mot_uav:angular/_update
```

编写_class，生成测试数据模板

```
#mot_scatter:_class
# 生成预设静态数据模板

# 生成测试数据模板
function mot_scatter:_zero
execute positioned 8 -59 8 rotated 0.0 0.0 as @e[tag=math_marker,limit=1] run function mot_scatter:_anchor_to
function mot_scatter:_model
data modify storage mot_scatter:class test set from storage mot_scatter:io result
```

修改test/display/start

```
#mot_scatter:test/display/start

# 生成测试程序实体
tag @e[tag=result] remove result
data modify storage mot_scatter:io input set from storage mot_scatter:class test
execute positioned 8 -59 8 run function mot_scatter:_new

...

# 设置测试程序运行时间
scoreboard players set @e[tag=result,limit=1] killtime 10
scoreboard players set test int 0
```

修改test/display/end

```
#mot_scatter:test/display/end

function mot_scatter:_del
```

修改test/display/main

```
#mot_scatter:test/display/main

# test置1结束测试
execute if score test int matches 1 run return fail

# 刷新存在时间
scoreboard players set @s killtime 10

# test置-1刷新实例
execute unless score test int matches -1 run return fail
scoreboard players set test int 0
execute as @e[tag=mot_scatter] run function mot_scatter:_del
function mot_scatter:test/display/start
```

修改main

```
#mot_scatter:main
# mot_scatter:tick调用
# 实体对象主程序

function mot_scatter:_get

function mot_scatter:update_barrel
scoreboard players set mot_uav_ch int 1250
scoreboard players operation tempid int = @s mot_uav_root
execute if score tempid int matches 0 run function mot_uav:device/_main_motion
execute if score tempid int matches 1.. if function mot_lamp:sync_uvw run function mot_uav:device/_main_sync

function mot_scatter:_store

# 坐标安全
execute unless score y int matches -640000..5120000 run function mot_uav:_del
```

进入游戏运行测试

```
reload
function mot_scatter:_init
```

放置循环命令方块运行tick

![alt text](images_part2/image-8.png)

```
function mot_scatter:tick
```

聊天栏调用测试

```
scoreboard players set test int 1
function mot_scatter:test/display/start
```

![alt text](images_part2/image-9.png)

观察到枪管乱成了一团

为了使得枪管朝向w轴方向（前方），我们修改update_barrel_phi

给计算结果右乘一个四元数q' = cos(45°) + sin(45°)*i

```
#mot_scatter:update_barrel_phi
# mot_scatter:update_barrel调用

# 计算本地四元数
scoreboard players operation psi int = temp_phi int
scoreboard players operation psi int += @s scatter_phi
execute as 0-0-0-0-0 run function math:iquat/_psi_to

# 计算局部坐标
scoreboard players operation @s u = iquat_w int
scoreboard players operation @s v = iquat_z int
scoreboard players operation @s u /= 10 int
scoreboard players operation @s v /= 10 int

# 右乘俯仰旋转
scoreboard players operation iquat_w int *= 70716 int
scoreboard players operation iquat_z int *= 70716 int
scoreboard players operation iquat_w int /= 100000 int
scoreboard players operation iquat_z int /= 100000 int
scoreboard players operation iquat_y int = iquat_z int
scoreboard players operation iquat_x int = iquat_w int

function math:iquat/_store
```

打开mot终端，创建接口_consts

```
creisp _consts
```

设置常量70716

```
#mot_scatter:_consts
# 创建常量

scoreboard players set 70716 int 70716
```

然后，我们修改_new函数，缩放枪管大小

```
#mot_scatter:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_scatter:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon item_display ~ ~ ~ {Tags:["mot_scatter", "result", "mot_device"],\
	item:{id:"minecraft:piston", count:1b},\
	transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.25f,0.25f,0.25f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f]},\
	CustomName:'"mot_scatter"',\
	teleport_duration:1, interpolation_duration:1,\
	Passengers:[\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_0","barrel","local_quat"],CustomName:'"mot_scatter_barrel_0"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.25f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_1","barrel","local_quat"],CustomName:'"mot_scatter_barrel_1"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.25f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_2","barrel","local_quat"],CustomName:'"mot_scatter_barrel_2"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.25f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_3","barrel","local_quat"],CustomName:'"mot_scatter_barrel_3"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.25f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_4","barrel","local_quat"],CustomName:'"mot_scatter_barrel_4"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.25f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_5","barrel","local_quat"],CustomName:'"mot_scatter_barrel_5"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.25f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
	]\
}
execute as @e[tag=result,limit=1] on passengers run function mot_uav:set_uvw
execute as @e[tag=result,limit=1] run function mot_scatter:set
execute as @e[tag=result,limit=1] run function mot_scatter:set_operations
```

进入游戏重新运行测试

```
scoreboard players set test int 1
reload
function mot_scatter:_init
function mot_scatter:test/display/start
```

![alt text](images_part2/image-10.png)

修改update_barrel_phi缩小枪管摆列半径

```
#mot_scatter:update_barrel_phi
# mot_scatter:update_barrel调用

...

# 计算局部坐标
scoreboard players operation @s u = iquat_w int
scoreboard players operation @s v = iquat_z int
scoreboard players operation @s u /= 15 int
scoreboard players operation @s v /= 15 int

...
```

继续调整枪管缩放

```
#mot_scatter:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_scatter:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon item_display ~ ~ ~ {Tags:["mot_scatter", "result", "mot_device"],\
	item:{id:"minecraft:piston", count:1b},\
	transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.25f,0.25f,0.25f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f]},\
	CustomName:'"mot_scatter"',\
	teleport_duration:1, interpolation_duration:1,\
	Passengers:[\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_0","barrel","local_quat"],CustomName:'"mot_scatter_barrel_0"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.45f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_1","barrel","local_quat"],CustomName:'"mot_scatter_barrel_1"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.45f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_2","barrel","local_quat"],CustomName:'"mot_scatter_barrel_2"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.45f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_3","barrel","local_quat"],CustomName:'"mot_scatter_barrel_3"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.45f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_4","barrel","local_quat"],CustomName:'"mot_scatter_barrel_4"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.45f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_5","barrel","local_quat"],CustomName:'"mot_scatter_barrel_5"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.45f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,1.0f]},interpolation_duration:1},\
	]\
}
execute as @e[tag=result,limit=1] on passengers run function mot_uav:set_uvw
execute as @e[tag=result,limit=1] run function mot_scatter:set
execute as @e[tag=result,limit=1] run function mot_scatter:set_operations
```

设置常量15

```
#mot_scatter:_consts
# 创建常量

scoreboard players set 70716 int 70716
scoreboard players set 15 int 15
```

进入游戏重新加载

```
reload
function mot_scatter:_init
scoreboard players set test int -1
```

![alt text](images_part2/image-11.png)

修改枪管的位移，并给活塞加上俯仰旋转

```
#mot_scatter:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_scatter:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon item_display ~ ~ ~ {Tags:["mot_scatter", "result", "mot_device"],\
	item:{id:"minecraft:piston", count:1b},\
	transformation:{right_rotation:[0.7071f,0f,0f,0.7071f],scale:[0.25f,0.25f,0.25f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f]},\
	CustomName:'"mot_scatter"',\
	teleport_duration:1, interpolation_duration:1,\
	Passengers:[\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_0","barrel","local_quat"],CustomName:'"mot_scatter_barrel_0"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.45f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.125f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_1","barrel","local_quat"],CustomName:'"mot_scatter_barrel_1"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.45f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.125f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_2","barrel","local_quat"],CustomName:'"mot_scatter_barrel_2"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.45f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.125f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_3","barrel","local_quat"],CustomName:'"mot_scatter_barrel_3"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.45f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.125f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_4","barrel","local_quat"],CustomName:'"mot_scatter_barrel_4"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.45f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.125f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_5","barrel","local_quat"],CustomName:'"mot_scatter_barrel_5"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.0625f,0.45f,0.0625f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.125f]},interpolation_duration:1},\
	]\
}
execute as @e[tag=result,limit=1] on passengers run function mot_uav:set_uvw
execute as @e[tag=result,limit=1] run function mot_scatter:set
execute as @e[tag=result,limit=1] run function mot_scatter:set_operations
```

进入游戏重新加载

```
reload
scoreboard players set test int -1
```

修改机枪整体的大小

```
#mot_scatter:collision/_load_data
# 加载机枪碰撞数据

# 碰撞点列表
data modify storage mot_uav:io collision_points set value [\
	[-0.375d, -0.375d, -0.375d],\
	[-0.375d, -0.375d, 0.375d],\
	[-0.375d, 0.375d, -0.375d],\
	[-0.375d, 0.375d, 0.375d],\
	[0.375d, -0.375d, -0.375d],\
	[0.375d, -0.375d, 0.375d],\
	[0.375d, 0.375d, -0.375d],\
	[0.375d, 0.375d, 0.375d]\
]

# 底盘距离
scoreboard players set mot_uav_ch int 3750

# 是否加载完成
return 1
```

```
#mot_scatter:main
# mot_scatter:tick调用
# 实体对象主程序

function mot_scatter:_get

function mot_scatter:update_barrel
scoreboard players operation tempid int = @s mot_uav_root
execute if score tempid int matches 0 run function mot_uav:device/_main_motion
execute if score tempid int matches 1.. if function mot_lamp:sync_uvw run function mot_uav:device/_main_sync

function mot_scatter:_store

# 坐标安全
execute unless score y int matches -640000..5120000 run function mot_uav:_del
```

```
#mot_scatter:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_scatter:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon item_display ~ ~ ~ {Tags:["mot_scatter", "result", "mot_device"],\
	item:{id:"minecraft:piston", count:1b},\
	transformation:{right_rotation:[0.7071f,0f,0f,0.7071f],scale:[0.75f,0.75f,0.75f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f]},\
	CustomName:'"mot_scatter"',\
	teleport_duration:1, interpolation_duration:1,\
	Passengers:[\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_0","barrel","local_quat"],CustomName:'"mot_scatter_barrel_0"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.1875f,1.0f,0.1875f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.375f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_1","barrel","local_quat"],CustomName:'"mot_scatter_barrel_1"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.1875f,1.0f,0.1875f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.375f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_2","barrel","local_quat"],CustomName:'"mot_scatter_barrel_2"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.1875f,1.0f,0.1875f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.375f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_3","barrel","local_quat"],CustomName:'"mot_scatter_barrel_3"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.1875f,1.0f,0.1875f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.375f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_4","barrel","local_quat"],CustomName:'"mot_scatter_barrel_4"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.1875f,1.0f,0.1875f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.375f]},interpolation_duration:1},\
		{id:"minecraft:item_display",Tags:["mot_scatter_display","barrel_5","barrel","local_quat"],CustomName:'"mot_scatter_barrel_5"',item:{id:"minecraft:decorated_pot",count:1b},transformation:{right_rotation:[0f,0f,0f,1f],scale:[0.1875f,1.0f,0.1875f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.375f]},interpolation_duration:1},\
	]\
}
execute as @e[tag=result,limit=1] on passengers run function mot_uav:set_uvw
execute as @e[tag=result,limit=1] run function mot_scatter:set
execute as @e[tag=result,limit=1] run function mot_scatter:set_operations
```

```
#mot_scatter:update_barrel_phi
# mot_scatter:update_barrel调用

# 计算本地四元数
scoreboard players operation psi int = temp_phi int
scoreboard players operation psi int += @s scatter_phi
execute as 0-0-0-0-0 run function math:iquat/_psi_to

# 计算局部坐标
scoreboard players operation @s u = iquat_w int
scoreboard players operation @s v = iquat_z int
scoreboard players operation @s u *= 9 int
scoreboard players operation @s v *= 9 int
scoreboard players operation @s u /= 40 int
scoreboard players operation @s v /= 40 int

# 右乘俯仰旋转
scoreboard players operation iquat_w int *= 70716 int
scoreboard players operation iquat_z int *= 70716 int
scoreboard players operation iquat_w int /= 100000 int
scoreboard players operation iquat_z int /= 100000 int
scoreboard players operation iquat_y int = iquat_z int
scoreboard players operation iquat_x int = iquat_w int

function math:iquat/_store
```

进入游戏重新加载

```
reload
scoreboard players set test int -1
```

![alt text](images_part2/image-12.png)

接下来，我们实现机枪的运行功能

修改main函数

```
#mot_scatter:main
# mot_scatter:tick调用
# 实体对象主程序

function mot_scatter:_get

scoreboard players operation tempid int = @s mot_uav_root
execute if score tempid int matches 0 run function mot_uav:device/_main_motion
execute if score tempid int matches 1.. if function mot_scatter:sync_uvw run function mot_uav:device/_main_sync
execute if entity @s[tag=triggered] run function mot_scatter:_run

function mot_scatter:_store

# 坐标安全
execute unless score y int matches -640000..5120000 run function mot_uav:_del
```

打开mot_scatter下的mot终端，创建_run, sync_uvw

```
cre _run sync_uvw
```

编写sync_uvw

```
#mot_scatter:sync_uvw
# mot_scatter:main调用

scoreboard players set mot_sync_u int 0
scoreboard players set mot_sync_v int 1250
scoreboard players set mot_sync_w int 0

execute if data storage mot_uav:io {slot_type:"left"} run scoreboard players set mot_sync_u int -3750
execute if data storage mot_uav:io {slot_type:"down"} run scoreboard players set mot_sync_v int 3750
execute if data storage mot_uav:io {slot_type:"right"} run scoreboard players set mot_sync_u int 3750

# 设置完成
return 1
```

编写_run

```
#mot_scatter:_run
# 运行机枪

# 转动枪管
scoreboard players add scatter_phi int 60000
scoreboard players operation scatter_phi int %= 3600000 int
scoreboard players operation temp_phi int = scatter_phi int
execute on passengers run function mot_scatter:update_barrel_phi

# 关闭静体优化
scoreboard players set motion_static int 0

tag @s remove triggered

# 无剩余子弹
execute if score bullet_res int matches ..0 run return run function mot_scatter:load_bullet
# 发射子弹
execute as 0-0-0-0-0 run function mot_scatter:shoot_bullet
```

创建load_bullet, shoot_bullet

```
cre load_bullet shoot_bullet
```

编写load_bullet

```
#mot_scatter:load_bullet
# mot_scatter:_run调用

scoreboard players set bullet_res int 120
execute at @s run playsound minecraft:block.piston.extend player @a ~ ~ ~ 1.0 1.5
```

编写shoot_bullet

```
#mot_scatter:shoot_bullet
# mot_scatter:_run调用

# 获取发射位置
scoreboard players set u int 0
scoreboard players set v int 2250
scoreboard players set w int 11250
function math:uvw/_topos

# 播放音效
scoreboard players operation temp_mod int = bullet_res int
scoreboard players operation temp_mod int %= 2 int
execute if score temp_mod int matches 0 at @s run playsound minecraft:entity.firework_rocket.blast player @a ~ ~ ~ 1.0 1.5

# 播放粒子
execute at @s run particle flame ~ ~ ~ 0.0 0.0 0.0 0.01 1

# 生成子弹
data modify storage mot_scatter:io input set from storage mot_scatter:class test_bullet
data modify storage mot_scatter:io input.position set from entity @s Pos
execute store result storage mot_scatter:io input.kvec[0] double 0.0001 run scoreboard players get kvec_x int
execute store result storage mot_scatter:io input.kvec[1] double 0.0001 run scoreboard players get kvec_y int
execute store result storage mot_scatter:io input.kvec[2] double 0.0001 run scoreboard players get kvec_z int
function mot_scatter:bullet/_new

scoreboard players remove bullet_res int 1
```

创建协议要求的设备接口

```
cre _sync_request _sync_coord _use_signal
```

```
#mot_scatter:_sync_request

# 采用默认实现
function mot_uav:device/_sync_request
```

```
#mot_scatter:_sync_coord

# 采用默认实现
function mot_uav:device/_sync_coord
```

```
#mot_scatter:_use_signal
# 输出<res,int>, 使用结束?1:0

scoreboard players set res int 0
execute if score @s bullet_res matches ..0 run scoreboard players set res int 1
tag @s add triggered
```

进入游戏，使用无人机装载机枪进行测试

```
reload
scoreboard players set test int -1
```

![alt text](images_part2/image-13.png)

无人机成功使用机枪开火

接下来编写mot_scatter:bullet模块

打开mot_scatter下的mot终端

```
cre bullet/init bullet/_consts bullet/_class bullet/_new bullet/set
```

创建bullet/.doc.mcfo

```
#mot_scatter:bullet/doc.mcfo

# 临时对象
_this:{
	position:{
		<x,int,1w>,
		<y,int,1w>,
		<z,int,1w>
	},
	kvec:{
		<kvec_x,int,1w>,
		<kvec_y,int,1w>,
		<kvec_z,int,1w>
	},
	killtime:<killtime,int>
}
```

修改_init，调用bullet/init

```
#mot_scatter:_init
# 初始化mot_scatter包

...

# 初始化子模块
function mot_scatter:bullet/init
```

编写bullet/init

```
#mot_scatter:bullet/init
# mot_scatter:_init调用

function mot_scatter:bullet/_consts
function mot_scatter:bullet/_class
```

编写bullet/_consts

```
#mot_scatter:bullet/_consts
# 设置常量

# 子弹单刻递归次数
scoreboard players set mot_bullet_loop int 20
```

编写bullet/_class

```
#mot_scatter:bullet/_class
# 生成静态数据模板

data modify storage mot_scatter:class test_bullet set value {position:[0.0d,0.0d,0.0d],kvec:[0.0d,0.0d,0.0d],killtime:5}
```

编写bullet/_new

```
#mot_scatter:bullet/_new
# 生成机枪子弹实例
# 输入数据模板[storage mot_scatter:io input]
# 输出实例entity @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon marker 0 0 0 {Tags:["mot_scatter_bullet","result"],CustomName:'"mot_scatter_bullet"'}
execute as @e[tag=result,limit=1] run function mot_scatter:bullet/set
```

编写bullet/set

```
#mot_scatter:bullet/set
# mot_scatter:bullet/_new调用

# 使用实例的NBT来储存数据，而不是通常的记分板
data modify entity @s Pos set from storage mot_scatter:io input.kvec
execute positioned 0.0 0.0 0.0 facing entity @s feet run tp @s ~ ~ ~ ~ ~
data modify entity @s Pos set from storage mot_scatter:io input.position

execute store result score @s killtime run data get storage mot_scatter:io input.killtime
```

接下来实现子弹的主程序

创建bullet/main, bullet/loop

```
cre bullet/main bullet/loop
```

编写bullet/main

```
#mot_scatter:bullet/main
# mot_scatter:tick调用

scoreboard players set res int 0
scoreboard players operation loop int = mot_bullet_loop int
function mot_scatter:bullet/loop
```

编写bullet/loop

```
#mot_scatter:bullet/loop
# mot_scatter:bullet/main调用

particle minecraft:crit ~ ~ ~
execute as @e[dx=0,dy=0,dz=0] positioned ~-0.999 ~-0.999 ~-0.999 if entity @s[dx=0,dy=0,dz=0] run function mot_scatter:bullet/hurt
execute positioned ^ ^ ^0.1 as @e[dx=0,dy=0,dz=0] positioned ~-0.999 ~-0.999 ~-0.999 if entity @s[dx=0,dy=0,dz=0] run function mot_scatter:bullet/hurt
execute positioned ^ ^ ^0.2 as @e[dx=0,dy=0,dz=0] positioned ~-0.999 ~-0.999 ~-0.999 if entity @s[dx=0,dy=0,dz=0] run function mot_scatter:bullet/hurt
execute positioned ^ ^ ^0.3 as @e[dx=0,dy=0,dz=0] positioned ~-0.999 ~-0.999 ~-0.999 if entity @s[dx=0,dy=0,dz=0] run function mot_scatter:bullet/hurt
execute positioned ^ ^ ^0.4 as @e[dx=0,dy=0,dz=0] positioned ~-0.999 ~-0.999 ~-0.999 if entity @s[dx=0,dy=0,dz=0] run function mot_scatter:bullet/hurt
execute unless block ~ ~ ~ #mot_uav:pass run scoreboard players set res int 1
execute if score res int matches 1 run return run scoreboard players set @s killtime 0

scoreboard players remove loop int 1
execute if score loop int matches ..0 positioned ^ ^ ^0.5 run tp @s ~ ~ ~
execute if score loop int matches 1.. positioned ^ ^ ^0.5 run function mot_scatter:bullet/loop
```

创建bullet/hurt

```
cre bullet/hurt
```

编写bullet/hurt

```
#mot_scatter:bullet/hurt
# mot_scatter:bullet/loop调用

execute at @s anchored eyes run particle minecraft:block_crumble{block_state:"minecraft:redstone_block"} ^ ^-0.5 ^ 0.2 0.2 0.2 0.05 1

execute store result score temp_hp int run data get entity @s Health 10
execute store result entity @s Health float 0.1 run scoreboard players remove temp_hp int 30

scoreboard players set res int 1
```

修改tick函数

```
#mot_scatter:tick

execute if entity @e[tag=mot_scatter,limit=1] if function mot_scatter:collision/_load_data as @e[tag=mot_scatter] run function mot_scatter:main

execute as @e[tag=mot_scatter_bullet] at @s run function mot_scatter:bullet/main
```

另外，我们加入一个特性，当无人机关闭电机后，所有装备卸载

打开mot_uav下的mot终端，创建_unload_all_devices

```
cre _unload_all_devices
```

编写_unload_all_devices

```
#mot_uav:_unload_all_devices
# 卸载所有装备
# 以无人机实例为执行者

scoreboard players set @s left_slot_id 0
scoreboard players set @s down_slot_id 0
scoreboard players set @s right_slot_id 0
```

修改fans/update_torch

```
#mot_uav:fans/update_torch
# mot_uav:fans/_on调用
# mot_uav:fans/_off调用
# mot_uav:fans/_update调用
# mot_uav:set_operations调用

...

execute if score @s fans_power matches 0 run data modify entity @s item.components."minecraft:custom_data".program.state set value 0
execute if score @s fans_power matches 0 run function mot_uav:_unload_all_devices
```

进入游戏运行测试

```
reload
function mot_scatter:bullet/init
scoreboard players set test int -1
```

![alt text](images_part2/image-14.png)

机枪成功发射子弹

### 3.2.2 添加激光设备

回到data目录，创建新的命名空间mot_laser

在mot_laser/function下部署新的mot副本

**请注意.mot_memory不要复制已有模块下的文件，因为这会继承白名单设置**

![alt text](images_part2/image-15.png)

修改.mot_memory/objects/global_settings.mcfo

```
# 无需初始化/创建的数据位置
global_default: {
	positions: {
		<@s, x>, <@s, y>, <@s, z>,
		<@s, x, 1w>, <@s, y, 1w>, <@s, z, 1w>
	},
	caches: {
		[storage math:io xyz, ListDouble, 3],
		[storage math:io xyzw, ListFloat, 4],
		[storage math:io rec, ListCompound, 1],
		[storage math:io rotation, ListFloat, 2]
	}
}

# 整数常量
int_consts: {-1, 0, 1, 2, 3, 4, 5, 10, 100, 1000, 10000}

# 项目名称
project_name:mot_laser

# 实体对象的数据位置
entity_store_path:item.components."minecraft:custom_data"

# 实体对象的类型
entity_type:item_display

# 初始化模块时创建的接口
init_interfaces:{
	_get,_store,_new,set,_del,main,tick
}
```

编写.doc.mcfo

```
#mot_laser:doc.mcfo

# 临时对象
_this:{
	bullet_res:<bullet_res,int>,
	slot_type:[storage mot_uav:io slot_type,String],
	mot_uav_root:<mot_uav_root,int>,
	static:<motion_static,int>,
	list_impulse:[storage mot_uav:io list_impulse,ListCompound],
	velocity:{<vx,int,1w>, <vy,int,1w>, <vz,int,1w>},
	angular_vec:{
		<angular_x,int,1w>,
		<angular_y,int,1w>,
		<angular_z,int,1w>
	},
	angular_len:<angular_len,int,1w>,
	position:{<x,int,1w>, <y,int,1w>, <z,int,1w>},
	uvw_coord:{
		ivec:{<ivec_x,int,1w>, <ivec_y,int,1w>, <ivec_z,int,1w>},
		jvec:{<jvec_x,int,1w>, <jvec_y,int,1w>, <jvec_z,int,1w>},
		kvec:{<kvec_x,int,1w>, <kvec_y,int,1w>, <kvec_z,int,1w>}
	},
	quaternion:{
		xyzw:{
			<quat_x,int,1w>,
			<quat_y,int,1w>,
			<quat_z,int,1w>,
			<quat_w,int,1w>
		},
		start_xyzw:{
			<quat_start_x,int,1w>,
			<quat_start_y,int,1w>,
			<quat_start_z,int,1w>,
			<quat_start_w,int,1w>
		},
		orth_xyzw:{
			<quat_orth_x,int,1w>,
			<quat_orth_y,int,1w>,
			<quat_orth_z,int,1w>,
			<quat_orth_w,int,1w>
		},
		phi:<quat_phi,int,1w>
	}
}
```

打开mot_laser下的mot终端，输入init命令，创建_init函数，初始化代码，并完成白名单设置

```
init
cre _init
sync
protect _init tick main _new _class _del
```

修改_init函数，完成模块注册

```
#mot_laser:_init
# 初始化mot_laser包

# 初始化模块控制
scoreboard objectives add int dummy
execute unless score module_control_inited int matches 1 run function module_control:_init

# 注册本模块
data modify storage module_control:io input set value {prefix:"mot_laser:",namespace:"mot_laser"}
function module_control:data/_reg
scoreboard players operation #mot_laser: module_id = res int

# 建立记分板
scoreboard objectives add bullet_res dummy
scoreboard objectives add mot_uav_root dummy

# 设置常量
function mot_laser:_consts

# 生成静态数据模板
function mot_laser:_class
```

打开mot_laser下的mot终端，创建collision/_load_data

```
cre collision/_load_data
```

编写collision/_load_data

```
#mot_laser:collision/_load_data
# 加载机枪碰撞数据

# 碰撞点列表
data modify storage mot_uav:io collision_points set value [\
	[-0.125d, -0.125d, -0.125d],\
	[-0.125d, -0.125d, 0.125d],\
	[-0.125d, 0.125d, -0.125d],\
	[-0.125d, 0.125d, 0.125d],\
	[0.125d, -0.125d, -0.125d],\
	[0.125d, -0.125d, 0.125d],\
	[0.125d, 0.125d, -0.125d],\
	[0.125d, 0.125d, 0.125d]\
]

scoreboard players set mot_uav_ch int 1250

# 是否加载完成
return 1
```

修改tick函数

```
#mot_laser:tick

execute if entity @e[tag=mot_laser,limit=1] if function mot_laser:collision/_load_data as @e[tag=mot_laser] run function mot_laser:main
```

修改_del函数

```
#mot_laser:_del
# 销毁实体对象
# 输入执行实体

data modify storage mot_uav:io free_addr prepend value 0
execute store result storage mot_uav:io free_addr[0] int 1 run scoreboard players get @s mot_uav_id

execute on passengers run kill @s
kill @s
```

修改_new函数

```
#mot_laser:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_laser:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon item_display ~ ~ ~ {Tags:["mot_laser", "result", "mot_device"],\
	item:{id:"minecraft:piston", count:1b},\
	transformation:{right_rotation:[0.7071f,0f,0f,0.7071f],scale:[0.25f,0.25f,0.25f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f]},\
	CustomName:'"mot_laser"',\
	teleport_duration:1, interpolation_duration:1,\
	Passengers:[\
		{id:"minecraft:item_display",Tags:["mot_laser_display","barrel_0","barrel"],CustomName:'"mot_laser_barrel_0"',item:{id:"minecraft:end_rod",count:1b},transformation:{right_rotation:[0.7071f,0f,0f,0.7071f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0.375f]},interpolation_duration:1}\
	]\
}
execute as @e[tag=result,limit=1] on passengers run function mot_uav:set_uvw
execute as @e[tag=result,limit=1] run function mot_laser:set
execute as @e[tag=result,limit=1] run function mot_laser:set_operations
```

打开mot_laser下的mot终端，创建set_operations

```
cre set_operations
```

编写set_operations

```
#mot_laser:set_operations
# mot_laser:_new调用

# 获取设备编号
function mot_uav:_new_id
scoreboard players operation @s mot_uav_id = res int

# 获取模块编号
scoreboard players operation @s module_id = #mot_laser: module_id
```

打开mot_laser下的mot终端，创建接口_class, _anchor_to, _zero, _model

然后创建一个异步测试项目命名为display

```
cre _class _anchor_to _zero _model
creisp test/display/start
```

实现_anchor_to接口，直接参照mot_uav:_anchor_to

```
#mot_laser:_anchor_to
# 输入执行坐标
# 输入执行朝向
# 需要传入世界实体为执行者

tp @s ~ ~ ~
data modify storage math:io xyz set from entity @s Pos
execute store result score x int run data get storage math:io xyz[0] 10000
execute store result score y int run data get storage math:io xyz[1] 10000
execute store result score z int run data get storage math:io xyz[2] 10000

function math:quat/_facing_to
function math:quat/_touvw

# 更新四元数旋转参数
function mot_uav:angular/_update
```

编写_class，生成测试数据模板

```
#mot_laser:_class
# 生成预设静态数据模板

# 生成测试数据模板
function mot_laser:_zero
execute positioned 8 -59 8 rotated 0.0 0.0 as @e[tag=math_marker,limit=1] run function mot_laser:_anchor_to
function mot_laser:_model
data modify storage mot_laser:class test set from storage mot_laser:io result
```

修改test/display/start

```
#mot_laser:test/display/start

# 生成测试程序实体
tag @e[tag=result] remove result
data modify storage mot_laser:io input set from storage mot_laser:class test
execute positioned 8 -59 8 run function mot_laser:_new

...

# 设置测试程序运行时间
scoreboard players set @e[tag=result,limit=1] killtime 10
scoreboard players set test int 0
```

修改test/display/end

```
#mot_laser:test/display/end

function mot_laser:_del
```

修改test/display/main

```
#mot_laser:test/display/main

# test置1结束测试
execute if score test int matches 1 run return fail

# 刷新存在时间
scoreboard players set @s killtime 10

# test置-1刷新实例
execute unless score test int matches -1 run return fail
scoreboard players set test int 0
execute as @e[tag=mot_laser] run function mot_laser:_del
function mot_laser:test/display/start
```

修改main

```
#mot_laser:main
# mot_laser:tick调用
# 实体对象主程序

function mot_laser:_get

scoreboard players operation tempid int = @s mot_uav_root
execute if score tempid int matches 0 run function mot_uav:device/_main_motion
execute if score tempid int matches 1.. if function mot_laser:sync_uvw run function mot_uav:device/_main_sync

function mot_laser:_store

# 坐标安全
execute unless score y int matches -640000..5120000 run function mot_uav:_del
```

进入游戏运行测试

```
reload
function mot_laser:_init
```

放置循环命令方块运行tick

```
function mot_laser:tick
```

![alt text](images_part2/image-16.png)

聊天栏调用测试

```
scoreboard players set test int 1
function mot_laser:test/display/start
```

![alt text](images_part2/image-17.png)

然后创建激光设备的协议接口

打开mot_laser下的mot终端，创建_sync_request, _sync_coord, _use_signal

```
cre _sync_request _sync_coord _use_signal
```

```
#mot_laser:_sync_request

# 采用默认实现
function mot_uav:device/_sync_request
```

```
#mot_laser:_sync_coord

# 采用默认实现
function mot_uav:device/_sync_coord
```

```
#mot_laser:_use_signal
# 输出<res,int>, 使用结束?1:0

scoreboard players set res int 1
tag @s add triggered
```

打开mot_laser下的mot终端，创建_run, sync_uvw

```
cre _run sync_uvw
```

实现sync_uvw

```
#mot_laser:sync_uvw
# mot_laser:main调用

scoreboard players set mot_sync_u int 0
scoreboard players set mot_sync_v int 0
scoreboard players set mot_sync_w int 0

execute if data storage mot_uav:io {slot_type:"left"} run scoreboard players set mot_sync_u int -1250
execute if data storage mot_uav:io {slot_type:"down"} run scoreboard players set mot_sync_v int 1250
execute if data storage mot_uav:io {slot_type:"right"} run scoreboard players set mot_sync_u int 1250

# 设置完成
return 1
```

实现_run

```
#mot_laser:_run
# 运行激光设备

tag @s remove triggered

# 无剩余子弹
execute if score bullet_res int matches ..0 at @s run return run playsound minecraft:block.chest.locked player @a ~ ~ ~ 1.0 2.0
# 发射子弹
execute as 0-0-0-0-0 run function mot_laser:shoot_bullet
```

创建shoot_bullet

```
cre shoot_bullet
```

实现shoot_bullet

```
#mot_laser:shoot_bullet
# mot_laser:_run调用

# 获取发射位置
scoreboard players set u int 0
scoreboard players set v int 0
scoreboard players set w int 6250
function math:uvw/_topos

# 播放音效
execute at @s run playsound minecraft:entity.evoker.cast_spell player @a ~ ~ ~ 1.0 2.0

# 生成子弹
data modify storage mot_laser:io input set from storage mot_scatter:class test_bullet
data modify storage mot_laser:io input.position set from entity @s Pos
execute store result storage mot_laser:io input.kvec[0] double 0.0001 run scoreboard players get kvec_x int
execute store result storage mot_laser:io input.kvec[1] double 0.0001 run scoreboard players get kvec_y int
execute store result storage mot_laser:io input.kvec[2] double 0.0001 run scoreboard players get kvec_z int
function mot_laser:bullet/_new

scoreboard players remove bullet_res int 20
```

修改main，调用激光冷却函数

```
#mot_laser:main
# mot_laser:tick调用
# 实体对象主程序

function mot_laser:_get

scoreboard players operation tempid int = @s mot_uav_root
execute if score tempid int matches 0 run function mot_uav:device/_main_motion
execute if score tempid int matches 1.. if function mot_laser:sync_uvw run function mot_uav:device/_main_sync
execute if score bullet_res int matches ..0 run function mot_laser:cooldown
execute if entity @s[tag=triggered] run function mot_laser:_run

function mot_laser:_store

# 坐标安全
execute unless score y int matches -640000..5120000 run function mot_uav:_del
```

创建cooldown

```
cre cooldown
```

实现cooldown

```
#mot_laser:cooldown
# mot_laser:main调用

scoreboard players add bullet_res int 1
execute if score bullet_res int matches 1 at @s run playsound minecraft:block.note_block.banjo player @a ~ ~ ~ 1.0 2.0
```

进入游戏运行测试

```
reload
scoreboard players set test int -1
```

![alt text](images_part2/image-18.png)

使用mot_uav能够激活设备

打开mot_laser下的mot终端，创建bullet/init, bullet/_consts, bullet/_class, bullet/_new, bullet/set, bullet/main, bullet/loop, bullet/hurt

```
cre bullet/init bullet/_consts bullet/_class bullet/_new bullet/set bullet/main bullet/loop bullet/hurt
```

创建bullet/.doc.mcfo

```
#mot_laser:bullet/doc.mcfo

# 临时对象
_this:{
	position:{
		<x,int,1w>,
		<y,int,1w>,
		<z,int,1w>
	},
	kvec:{
		<kvec_x,int,1w>,
		<kvec_y,int,1w>,
		<kvec_z,int,1w>
	},
	killtime:<killtime,int>
}
```

实现bullet/init

```
#mot_laser:bullet/init
# mot_laser:_init调用

function mot_laser:bullet/_consts
function mot_laser:bullet/_class
```

修改_init，调用bullet/init

```
#mot_laser:_init
# 初始化mot_laser包

...

# 初始化子模块
function mot_laser:bullet/init
```

实现bullet/_consts

```
#mot_laser:bullet/_consts
# 设置常量

# 子弹单刻递归次数
scoreboard players set mot_laser_loop int 50
```

实现bullet/_class

```
#mot_laser:bullet/_class
# 生成静态数据模板

data modify storage mot_laser:class test_bullet set value {position:[0.0d,0.0d,0.0d],kvec:[0.0d,0.0d,0.0d],killtime:10}
```

实现bullet/_new, bullet/set

```
#mot_laser:bullet/_new
# 生成机枪子弹实例
# 输入数据模板[storage mot_laser:io input]
# 输出实例entity @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon marker 0 0 0 {Tags:["mot_laser_bullet","result"],CustomName:'"mot_laser_bullet"'}
execute as @e[tag=result,limit=1] run function mot_laser:bullet/set
```

```
#mot_laser:bullet/set
# mot_laser:bullet/_new调用

# 使用实例的NBT来储存数据，而不是通常的记分板
data modify entity @s Pos set from storage mot_laser:io input.kvec
execute positioned 0.0 0.0 0.0 facing entity @s feet run tp @s ~ ~ ~ ~ ~
data modify entity @s Pos set from storage mot_laser:io input.position

execute store result score @s killtime run data get storage mot_laser:io input.killtime
```

实现bullet/main, bullet/loop, bullet/hurt

```
#mot_laser:bullet/main
# mot_laser:tick调用

scoreboard players set res int 0
scoreboard players operation loop int = mot_laser_loop int
function mot_laser:bullet/loop
```

```
#mot_laser:bullet/loop
# mot_laser:bullet/main调用

particle minecraft:end_rod ~ ~ ~
execute as @e[dx=0,dy=0,dz=0] positioned ~-0.999 ~-0.999 ~-0.999 if entity @s[dx=0,dy=0,dz=0] run function mot_laser:bullet/hurt

scoreboard players remove loop int 1
execute if score loop int matches ..0 positioned ^ ^ ^0.1 run tp @s ~ ~ ~
execute if score loop int matches 1.. positioned ^ ^ ^0.1 run function mot_laser:bullet/loop
```

```
#mot_laser:bullet/hurt
# mot_laser:bullet/loop调用

execute store result score temp_hp int run data get entity @s Health 10
execute store result entity @s Health float 0.1 run scoreboard players remove temp_hp int 100
```

修改tick，调用bullet/tick

```
#mot_laser:tick

execute if entity @e[tag=mot_laser,limit=1] if function mot_laser:collision/_load_data as @e[tag=mot_laser] run function mot_laser:main

execute as @e[tag=mot_laser_bullet] at @s run function mot_laser:bullet/main
```

进入游戏重新测试

```
reload
function mot_laser:_init
scoreboard players set test int -1
```

![alt text](images_part2/image-19.png)

成功发射激光

### 3.2.3 添加瞄准程序

在mot_uav命名空间下，创建program/facing/.doc.mcfo

```
#mot_uav:program/facing/doc.mcfo

# 位移控制程序的临时对象
_this: {
	pointer: [storage mot_uav:io ptr,String],
	target_y: <target_y,int,1w>,
	facing_pos: {
		<vec_x,int,1w>,
		<vec_y,int,1w>,
		<vec_z,int,1w>
	},
	damp_params: {
		<damp_k,int,1w>,
		<damp_b,int,1w>,
		<damp_f,int,1w>
	},
	state: <state,int,1>
}
```

打开mot_uav下的mot终端，创建program/facing/_proj, program/facing/_model, program/facing/_run

编写program/facing/_proj, program/facing/_model

```
#mot_uav:program/facing/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score target_y int run data get storage mot_uav:io input.target_y 10000
execute store result score vec_x int run data get storage mot_uav:io input.facing_pos[0] 10000
execute store result score vec_y int run data get storage mot_uav:io input.facing_pos[1] 10000
execute store result score vec_z int run data get storage mot_uav:io input.facing_pos[2] 10000
execute store result score damp_k int run data get storage mot_uav:io input.damp_params[0] 10000
execute store result score damp_b int run data get storage mot_uav:io input.damp_params[1] 10000
execute store result score damp_f int run data get storage mot_uav:io input.damp_params[2] 10000
execute store result score state int run data get storage mot_uav:io input.state
```

```
#mot_uav:program/facing/_model
# 使用临时对象构建数据模板
# 输出[storage mot_uav:io result]

data modify storage mot_uav:io result set value {pointer:"", target_y:0.0d, facing_pos:[0.0d,0.0d,0.0d], damp_params:[0.0d,0.0d,0.0d], state:0}

data modify storage mot_uav:io result.pointer set from storage mot_uav:io ptr
execute store result storage mot_uav:io result.target_y double 0.0001 run scoreboard players get target_y int
execute store result storage mot_uav:io result.facing_pos[0] double 0.0001 run scoreboard players get vec_x int
execute store result storage mot_uav:io result.facing_pos[1] double 0.0001 run scoreboard players get vec_y int
execute store result storage mot_uav:io result.facing_pos[2] double 0.0001 run scoreboard players get vec_z int
execute store result storage mot_uav:io result.damp_params[0] double 0.0001 run scoreboard players get damp_k int
execute store result storage mot_uav:io result.damp_params[1] double 0.0001 run scoreboard players get damp_b int
execute store result storage mot_uav:io result.damp_params[2] double 0.0001 run scoreboard players get damp_f int
execute store result storage mot_uav:io result.state int 1 run scoreboard players get state int
```

实现program/facing/_run

```
#mot_uav:program/facing/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

scoreboard players operation sstemp_vx int = vec_x int
scoreboard players operation sstemp_vy int = vec_y int
scoreboard players operation sstemp_vz int = vec_z int
scoreboard players operation vec_x int -= x int
scoreboard players operation vec_y int -= y int
scoreboard players operation vec_z int -= z int
function math:vec/_unit_xz
scoreboard players operation uvec_y int > -3333 int
scoreboard players operation uvec_y int < 3333 int
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get uvec_x int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players get uvec_y int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get uvec_z int
data modify entity @s Pos set from storage math:io xyz
execute positioned 0.0 0.0 0.0 facing entity @s feet run function math:iquat/_facing_to

# 计算转轴和角度差
scoreboard players operation quat_x int *= -1 int
scoreboard players operation quat_y int *= -1 int
scoreboard players operation quat_z int *= -1 int
function math:quat/_mult
scoreboard players operation quat_x int *= -1 int
scoreboard players operation quat_y int *= -1 int
scoreboard players operation quat_z int *= -1 int
execute if score rquat_w int matches ..-1 run function math:rquat/_neg
function math:rquat/_touvec
scoreboard players operation res int *= -2 int
scoreboard players add res int 10000
scoreboard players operation cos int = res int
function math:_arccos
scoreboard players operation damp_x int = theta int
scoreboard players operation damp_x int *= -1 int

# 计算当前角速度沿转轴分量
scoreboard players operation damp_v int = angular_x int
scoreboard players operation damp_v int *= uvec_x int
scoreboard players operation temp int = angular_y int
scoreboard players operation temp int *= uvec_y int
scoreboard players operation damp_v int += temp int
scoreboard players operation temp int = angular_z int
scoreboard players operation temp int *= uvec_z int
scoreboard players operation damp_v int += temp int
scoreboard players operation damp_v int /= 10000 int

# 阻尼迭代
function math:damp/_iter

scoreboard players set state int 1
# 判定阻尼运动终止
function math:damp/_energy
scoreboard players operation temp_e int = res int
function math:damp/_threshold
scoreboard players operation res int *= 10 int
execute if score temp_e int <= res int run scoreboard players set state int 2
execute if score temp_e int <= res int run scoreboard players set damp_v int 0

# 更新角速度
scoreboard players operation angular_x int = uvec_x int
scoreboard players operation angular_y int = uvec_y int
scoreboard players operation angular_z int = uvec_z int
scoreboard players operation angular_x int *= damp_v int
scoreboard players operation angular_y int *= damp_v int
scoreboard players operation angular_z int *= damp_v int
scoreboard players operation angular_x int /= 10000 int
scoreboard players operation angular_y int /= 10000 int
scoreboard players operation angular_z int /= 10000 int
function mot_uav:angular/_update

scoreboard players operation vec_x int = sstemp_vx int
scoreboard players operation vec_y int = sstemp_vy int
scoreboard players operation vec_z int = sstemp_vz int
function mot_uav:program/facing/_model
data modify storage mot_uav:io temp set from storage mot_uav:io result

# 维持高度
data modify storage mot_uav:io input set from storage mot_uav:class default_programs[{id:"height"}]
execute store result storage mot_uav:io input.target_y double 0.0001 run scoreboard players get target_y int
function mot_uav:program/height/_proj
function mot_uav:program/height/_run

data modify storage mot_uav:io input set from storage mot_uav:io temp
function mot_uav:program/facing/_proj
```

创建program/compose/.doc.mcfo

```
#mot_uav:program/compose/doc.mcfo

# 高度控制程序的临时对象
_this: {
	pointer: [storage mot_uav:io ptr,String],
	state: <state,int,1>,
	list_programs: [storage mot_uav:io list_programs, ListCompound]
}
```

打开mot_uav下的mot终端，创建program/compose/_proj, program/compose/_model, program/compose/_run

```
cre program/compose/_proj program/compose/_model program/compose/_run
```

编写program/compose/_proj, program/compose/_model

```
#mot_uav:program/compose/_proj
# 数据模板投射到临时对象
# 输入[storage mot_uav:io input]

data modify storage mot_uav:io ptr set from storage mot_uav:io input.pointer
execute store result score state int run data get storage mot_uav:io input.state
data modify storage mot_uav:io list_programs set from storage mot_uav:io input.list_programs
```

```
#mot_uav:program/compose/_proj
# 使用临时对象构建数据模板
# 输出[storage mot_uav:io result]

data modify storage mot_uav:io result set value {pointer:"", state:0, list_programs:[]}

data modify storage mot_uav:io result.pointer set from storage mot_uav:io pointer
execute store result storage mot_uav:io result.state int 1 run scoreboard players get state int
data modify storage mot_uav:io result.list_programs set from storage mot_uav:io list_programs
```

实现program/compose/_run

```
#mot_uav:program/compose/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

data modify storage mot_uav:io input set from storage mot_uav:io list_programs[0]
execute store result score ssloop int run data get storage mot_uav:io list_programs
execute if score ssloop int matches 1.. run function mot_uav:program/compose/run_loop with storage mot_uav:io input

scoreboard players set state int 2
execute if data storage mot_uav:io list_programs[{state:0}] run scoreboard players set state int 0
execute if data storage mot_uav:io list_programs[{state:1}] run scoreboard players set state int 1
execute if data storage mot_uav:io list_programs[{state:-1}] run scoreboard players set state int -1
data modify storage mot_uav:io ptr set value "mot_uav:program/compose"
```

创建program/compose/run_loop

```
cre program/compose/run_loop
```

```
#mot_uav:program/compose/run_loop
# mot_uav:program/compose/_run调用

$function $(pointer)/_proj
$function $(pointer)/_run
$function $(pointer)/_model

data modify storage mot_uav:io list_programs[0] set from storage mot_uav:io result
data modify storage mot_uav:io list_programs append from storage mot_uav:io list_programs[0]
data remove storage mot_uav:io list_programs[0]
data modify storage mot_uav:io input set from storage mot_uav:io list_programs[0]
scoreboard players remove ssloop int 1
execute if score ssloop int matches 1.. run function mot_uav:program/compose/run_loop with storage mot_uav:io input
```

修改program/init

```
#mot_uav:program/init
# mot_uav:_init调用

scoreboard players set -3333 int -3333
scoreboard players set 3333 int 3333

# 预设控制程序的数据模板
data modify storage mot_uav:class default_programs set value [\
	{id:"compose", pointer:"mot_uav:program/compose", state:0, list_programs:[]},\
	{id:"waiting", pointer:"mot_uav:program/waiting", state:0, wait_time:-1},\
	{id:"landing", pointer:"mot_uav:program/landing", state:0},\
	{id:"near_landing", pointer:"mot_uav:program/near_landing", state:0},\
	{id:"left_connect", pointer:"mot_uav:program/left_connect", state:0},\
	{id:"left_deconnect", pointer:"mot_uav:program/left_deconnect", state:0},\
	{id:"left_use", pointer:"mot_uav:program/left_use", state:0},\
	{id:"down_connect", pointer:"mot_uav:program/down_connect", state:0},\
	{id:"down_deconnect", pointer:"mot_uav:program/down_deconnect", state:0},\
	{id:"down_use", pointer:"mot_uav:program/down_use", state:0},\
	{id:"right_connect", pointer:"mot_uav:program/right_connect", state:0},\
	{id:"right_deconnect", pointer:"mot_uav:program/right_deconnect", state:0},\
	{id:"right_use", pointer:"mot_uav:program/right_use", state:0},\
	{id:"height", pointer:"mot_uav:program/height", target_y:0.0d, damp_params:[0.95d,1.0d,0.008d], state:0},\
	{id:"rotation", pointer:"mot_uav:program/rotation", target_y:0.0d, target_theta:0.0d, damp_params:[0.0095d,0.01d,0.08d], state:0},\
	{id:"position", pointer:"mot_uav:program/position", target_y:0.0d, target_pos:[0.0d,0.0d,0.0d], damp_params:[0.95d,1.0d,0.008d], state:0},\
	{id:"up", pointer:"mot_uav:program/up", delta_y:0.0d, target_y:0.0d, damp_params:[0.95d,1.0d,0.008d], state:0},\
	{id:"turn", pointer:"mot_uav:program/turn", delta_theta:0.0d, target_y:0.0d, target_theta:0.0d, damp_params:[0.0095d,0.01d,0.08d], state:0},\
	{id:"forward", pointer:"mot_uav:program/forward", u:0.0d, v:0.0d, w:0.0d, target_y:0.0d, target_pos:[0.0d,0.0d,0.0d], damp_params:[0.95d,1.0d,0.008d], state:0},\
	{id:"facing", pointer:"mot_uav:program/facing", target_y:0.0d, facing_pos:[0.0d,0.0d,0.0d], damp_params:[0.0095d,0.01d,0.08d], state:0}\
]
```

打开mot终端，创建异步测试项目命名为facing

```
creisp test/facing/start
```

修改test/facing/start

```
#mot_uav:test/facing/start

# 生成测试程序实体
function mot_scatter:_init
data modify storage mot_scatter:io input set from storage mot_scatter:class test
function mot_scatter:_new
tag @e[tag=result,limit=1] add test_device
data modify storage mot_uav:io input set from storage mot_uav:class test
function mot_uav:_new

execute as @e[tag=result,limit=1] run function marker_control:data/_get

# 控制程序管线
data modify storage marker_control:io result.lst_programs set value []
# 上升1格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"up"}]
data modify storage marker_control:io result.lst_programs[-1].delta_y set value 1.0d
# 下降2.8格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"up"}]
data modify storage marker_control:io result.lst_programs[-1].delta_y set value -2.8d
# 右偏1.0格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"forward"}]
data modify storage marker_control:io result.lst_programs[-1].u set value -1.0d
data remove storage marker_control:io result.lst_programs[-1].target_y
# 下降0.5格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"up"}]
data modify storage marker_control:io result.lst_programs[-1].delta_y set value -0.5d
# 连接设备
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"left_connect"}]
# 装填子弹
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"left_use"}]
# 上升1.5格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"up"}]
data modify storage marker_control:io result.lst_programs[-1].delta_y set value 1.5d
# 旋转并射击
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"compose"}]
data modify storage marker_control:io result.lst_programs[-1].list_programs append from storage mot_uav:class default_programs[{id:"turn"}]
data modify storage marker_control:io result.lst_programs[-1].list_programs[-1].delta_theta set value -90.0d
data remove storage marker_control:io result.lst_programs[-1].list_programs[-1].target_y
data modify storage marker_control:io result.lst_programs[-1].list_programs append from storage mot_uav:class default_programs[{id:"left_use"}]
# 下降0.5格
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"up"}]
data modify storage marker_control:io result.lst_programs[-1].delta_y set value -0.5d
# 左移并射击
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"compose"}]
data modify storage marker_control:io result.lst_programs[-1].list_programs append from storage mot_uav:class default_programs[{id:"forward"}]
data modify storage marker_control:io result.lst_programs[-1].list_programs[-1].u set value 5.0d
data remove storage marker_control:io result.lst_programs[-1].list_programs[-1].target_y
data modify storage marker_control:io result.lst_programs[-1].list_programs append from storage mot_uav:class default_programs[{id:"left_use"}]
# 等待
data modify storage marker_control:io result.lst_programs append from storage mot_uav:class default_programs[{id:"waiting"}]
data modify storage marker_control:io result.lst_programs[-1].end_mark set value 1b
# 结束标记
data modify storage marker_control:io result.lst_programs append value {}

# 设置测试程序主函数和销毁函数
data modify storage marker_control:io result.tick_funcs set value ["mot_uav:test/facing/main","mot_uav:test/program/main"]
data modify storage marker_control:io result.del_func set value "mot_uav:test/facing/end"

execute as @e[tag=result,limit=1] run function marker_control:data/_store
tag @e[tag=result,limit=1] add entity_ticked
tag @e[tag=result,limit=1] add entity_todel

# 设置测试程序运行时间
scoreboard players set @e[tag=result,limit=1] killtime 500
```

修改test/facing/main

```
#mot_uav:test/facing/main

function mot_uav:_get

execute unless entity @s[tag=mot_uav_facing_test] if data storage mot_uav:io program{pointer:"mot_uav:program/waiting"} run function mot_uav:test/facing/end_s0
execute unless entity @s[tag=mot_uav_facing_test] run return fail

function marker_control:data/_get
data modify storage mot_uav:io temp_state set from storage marker_control:io result.state
execute if data storage mot_uav:io {temp_state:"get_enemy"} run function mot_uav:test/facing/get_enemy
execute if data storage mot_uav:io {temp_state:"rotating"} run function mot_uav:test/facing/rotating
execute if data storage mot_uav:io {temp_state:"attacking"} run function mot_uav:test/facing/attacking
function marker_control:data/_store
function mot_uav:_store
```

创建test/facing/end_s0, test/facing/get_enemy, test/facing/rotating, test/facing/attacking

```
cre test/facing/end_s0 test/facing/get_enemy test/facing/rotating test/facing/attacking
```

编写test/facing/end_s0

```
#mot_uav:test/facing/end_s0
# mot_uav:test/facing/main调用

function marker_control:data/_get

data remove storage marker_control:io result.tick_funcs[-1]
tag @s add mot_uav_facing_test
data modify storage marker_control:io result.state set value "get_enemy"

function marker_control:data/_store

scoreboard players set @s killtime 500
```

编写test/facing/get_enemy

```
#mot_uav:test/facing/get_enemy
# mot_uav:test/facing/main调用

tag @e[tag=result] remove result
execute at @s run tag @e[type=minecraft:pillager,limit=1,sort=random,distance=..30] add result
execute unless entity @e[tag=result,limit=1] run return run function mot_uav:facing/enemy_not_found
data modify storage marker_control:io result.enemy_uuid set from entity @e[tag=result,limit=1] UUID

data modify storage marker_control:io result.state set value "rotating"
data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"facing"}]
data modify storage math:io xyz set from entity @e[tag=math_marker,limit=1] Pos
execute store result score vec_x int run data get storage math:io xyz[0] 10000
execute store result score vec_y int run data get storage math:io xyz[1] 10000
execute store result score vec_z int run data get storage math:io xyz[2] 10000
scoreboard players operation vec_x int -= x int
scoreboard players operation vec_y int -= y int
scoreboard players operation vec_z int -= z int
scoreboard players set u int 6250
scoreboard players set v int 1000
scoreboard players set w int 11250
execute as @e[tag=math_marker,limit=1] run function math:rot/_local_facing
execute as @e[tag=math_marker,limit=1] run function math:rot/_tovec
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players operation vec_x int += x int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players operation vec_y int += y int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players operation vec_z int += z int
data modify storage mot_uav:io program.facing_pos set from storage math:io xyz
execute store result storage mot_uav:io program.target_y double 0.0001 run scoreboard players get y int
```

编写test/facing/rotating

```
#mot_uav:test/facing/rotating
# mot_uav:test/facing/main调用

tag @e[tag=result] remove result
data modify entity @e[tag=uuid_marker,limit=1] Thrower set from storage marker_control:io result.enemy_uuid
execute as @e[tag=uuid_marker,limit=1] on origin run tag @s add result
execute unless entity @e[tag=result,limit=1] run return run data modify storage marker_control:io result.state set value "get_enemy"

execute if data storage mot_uav:io program{state:2} run return run function mot_uav:test/facing/s_attacking

execute as @e[tag=result] at @s anchored eyes run tp @e[tag=math_marker,limit=1] ^ ^-0.5 ^
execute store result score target_y int run data get storage mot_uav:io program.target_y 10000
data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"facing"}]
data modify storage math:io xyz set from entity @e[tag=math_marker,limit=1] Pos
execute store result score vec_x int run data get storage math:io xyz[0] 10000
execute store result score vec_y int run data get storage math:io xyz[1] 10000
execute store result score vec_z int run data get storage math:io xyz[2] 10000
scoreboard players operation vec_x int -= x int
scoreboard players operation vec_y int -= y int
scoreboard players operation vec_z int -= z int
scoreboard players set u int 6250
scoreboard players set v int 1000
scoreboard players set w int 11250
execute as @e[tag=math_marker,limit=1] run function math:rot/_local_facing
execute as @e[tag=math_marker,limit=1] run function math:rot/_tovec
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players operation vec_x int += x int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players operation vec_y int += y int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players operation vec_z int += z int
data modify storage mot_uav:io program.facing_pos set from storage math:io xyz
execute store result storage mot_uav:io program.target_y double 0.0001 run scoreboard players get target_y int
```

编写test/facing/attacking

```
#mot_uav:test/facing/attacking
# mot_uav:test/facing/main调用

execute store result score temp_cnt int run data get storage marker_control:io result.attack_cnt
execute store result storage marker_control:io result.attack_cnt int 1 run scoreboard players remove temp_cnt int 1
execute if score temp_cnt int matches ..0 run return run function mot_uav:test/facing/s_get_enemy

data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"compose"}]
data modify storage mot_uav:io program.list_programs append from storage marker_control:io result.facing_program
data modify storage mot_uav:io program.list_programs append from storage mot_uav:class default_programs[{id:"left_use"}]
```

创建test/facing/s_attacking, test/facing/s_get_enemy, test/facing/enemy_not_found

```
cre test/facing/s_attacking test/facing/s_get_enemy test/facing/enemy_not_found
```

编写test/facing/s_attacking

```
#mot_uav:test/facing/s_attacking
# mot_uav:test/facing/rotating调用

data modify storage marker_control:io result.attack_cnt set value 20
data modify storage marker_control:io result.state set value "attacking"
data modify storage marker_control:io result.facing_program set from storage mot_uav:io program
```

编写test/facing/s_get_enemy

```
#mot_uav:test/facing/s_get_enemy
# mot_uav:test/facing/attacking调用

data modify storage mot_uav:io program set value {}
data modify storage marker_control:io result.state set value "get_enemy"
```

编写test/facing/enemy_not_found

```
#mot_uav:test/facing/enemy_not_found
# mot_uav:test/facing/get_enemy调用

execute store result score target_y int run data get storage mot_uav:io program.target_y 10000
data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"waiting"}]
execute store result storage mot_uav:io program.target_y double 0.0001 run scoreboard players get target_y int
```

修改test/facing/end

```
#mot_uav:test/facing/end

execute as @e[tag=test_device] run function module_control:_call_method {path:"_del"}
function mot_uav:_del
```

修改test/program/upload_program

```
#mot_uav:test/program/upload_program
# mot_uav:test/program/main调用

...

# 上传新程序
data modify storage mot_uav:io program set from storage marker_control:io result.lst_programs[0]
data remove storage marker_control:io result.lst_programs[0]
function marker_control:data/_store
execute unless data storage mot_uav:io program.target_y \
	store result storage mot_uav:io program.target_y double 0.0001 run \
	scoreboard players get test_y int
execute if data storage mot_uav:io program.list_programs[0] \
	store result storage mot_uav:io program.list_programs[].target_y double 0.0001 run \
	scoreboard players get test_y int
data modify storage mot_uav:io program.state set value 1
tellraw @a ["pointer: ", {"nbt":"program.pointer","storage":"mot_uav:io"}]
function mot_uav:_store_program

...
```

进入游戏运行测试

```
scoreboard players set test int 1
reload
function math:test/facing/start
```

![alt text](images_part2/image-20.png)

观察到无人机自动瞄准敌人

### 3.2.4 添加方块搬运器设备

回到data目录，创建新的命名空间mot_mover

在mot_mover/function下部署新的mot副本

**请注意.mot_memory不要复制已有模块下的文件，因为这会继承白名单设置**

![alt text](images_part2/image-21.png)

修改.mot_memory/objects/global_settings.mcfo

```
# 无需初始化/创建的数据位置
global_default: {
	positions: {
		<@s, x>, <@s, y>, <@s, z>,
		<@s, x, 1w>, <@s, y, 1w>, <@s, z, 1w>
	},
	caches: {
		[storage math:io xyz, ListDouble, 3],
		[storage math:io xyzw, ListFloat, 4],
		[storage math:io rec, ListCompound, 1],
		[storage math:io rotation, ListFloat, 2]
	}
}

# 整数常量
int_consts: {-1, 0, 1, 2, 3, 4, 5, 10, 100, 1000, 10000}

# 项目名称
project_name:mot_mover

# 实体对象的数据位置
entity_store_path:item.components."minecraft:custom_data"

# 实体对象的类型
entity_type:item_display

# 初始化模块时创建的接口
init_interfaces:{
	_get,_store,_new,set,_del,main,tick
}
```

编写.doc.mcfo

```
#mot_mover:doc.mcfo

# 临时对象
_this:{
	block_plate:{
		block_id:[storage mot_mover:io block_id,String],
		block_state:[storage mot_mover:io block_state,Compound],
		block_nbt:[storage mot_mover:io block_nbt,Compound]
	},
	slot_type:[storage mot_uav:io slot_type,String],
	mot_uav_root:<mot_uav_root,int>,
	static:<motion_static,int>,
	list_impulse:[storage mot_uav:io list_impulse,ListCompound],
	velocity:{<vx,int,1w>, <vy,int,1w>, <vz,int,1w>},
	angular_vec:{
		<angular_x,int,1w>,
		<angular_y,int,1w>,
		<angular_z,int,1w>
	},
	angular_len:<angular_len,int,1w>,
	position:{<x,int,1w>, <y,int,1w>, <z,int,1w>},
	uvw_coord:{
		ivec:{<ivec_x,int,1w>, <ivec_y,int,1w>, <ivec_z,int,1w>},
		jvec:{<jvec_x,int,1w>, <jvec_y,int,1w>, <jvec_z,int,1w>},
		kvec:{<kvec_x,int,1w>, <kvec_y,int,1w>, <kvec_z,int,1w>}
	},
	quaternion:{
		xyzw:{
			<quat_x,int,1w>,
			<quat_y,int,1w>,
			<quat_z,int,1w>,
			<quat_w,int,1w>
		},
		start_xyzw:{
			<quat_start_x,int,1w>,
			<quat_start_y,int,1w>,
			<quat_start_z,int,1w>,
			<quat_start_w,int,1w>
		},
		orth_xyzw:{
			<quat_orth_x,int,1w>,
			<quat_orth_y,int,1w>,
			<quat_orth_z,int,1w>,
			<quat_orth_w,int,1w>
		},
		phi:<quat_phi,int,1w>
	}
}
```

打开mot_mover下的mot终端，输入init命令，创建_init函数，初始化代码，并完成白名单设置

```
init
cre _init
sync
protect _init tick main _new _class _del
```

修改_init函数，完成模块注册

```
#mot_mover:_init
# 初始化mot_mover包

# 初始化模块控制
scoreboard objectives add int dummy
execute unless score module_control_inited int matches 1 run function module_control:_init

# 注册本模块
data modify storage module_control:io input set value {prefix:"mot_mover:",namespace:"mot_mover"}
function module_control:data/_reg
scoreboard players operation #mot_mover: module_id = res int

# 建立记分板
scoreboard objectives add mot_uav_root dummy

# 设置常量
function mot_mover:_consts

# 生成静态数据模板
function mot_mover:_class
```

打开mot_mover下的mot终端，创建collision/_load_data

```
cre collision/_load_data
```

编写collision/_load_data

```
#mot_mover:collision/_load_data
# 加载搬运器碰撞数据

# 碰撞点列表
data modify storage mot_uav:io collision_points set value [\
	[-0.125d, -0.125d, -0.125d],\
	[-0.125d, -0.125d, 0.125d],\
	[-0.125d, 0.125d, -0.125d],\
	[-0.125d, 0.125d, 0.125d],\
	[0.125d, -0.125d, -0.125d],\
	[0.125d, -0.125d, 0.125d],\
	[0.125d, 0.125d, -0.125d],\
	[0.125d, 0.125d, 0.125d]\
]

scoreboard players set mot_uav_ch int 1250

execute unless data storage mot_mover:io {block_id:""} run \
	data modify storage mot_uav:io collision_points set value [\
	[-0.5d, -1.125d, -0.5d],\
	[-0.5d, -1.125d, 0.5d],\
	[-0.5d, -0.125d, -0.5d],\
	[-0.5d, -0.125d, 0.5d],\
	[0.5d, -1.125d, -0.5d],\
	[0.5d, -1.125d, 0.5d],\
	[0.5d, -0.125d, -0.5d],\
	[0.5d, -0.125d, 0.5d]\
]

execute unless data storage mot_mover:io {block_id:""} run \
	scoreboard players set mot_uav_ch int 11250

# 是否加载完成
return 1
```

修改_del函数

```
#mot_mover:_del
# 销毁实体对象
# 输入执行实体

data modify storage mot_uav:io free_addr prepend value 0
execute store result storage mot_uav:io free_addr[0] int 1 run scoreboard players get @s mot_uav_id

execute on passengers run kill @s
kill @s
```

修改_new函数

```
#mot_mover:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_mover:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon item_display ~ ~ ~ {Tags:["mot_mover", "result", "mot_device"],\
	item:{id:"minecraft:tripwire_hook", count:1b},\
	transformation:{right_rotation:[1f,0f,0f,0f],scale:[1f,1f,1f],left_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f]},\
	CustomName:'"mot_mover"',\
	teleport_duration:1, interpolation_duration:1,\
	Passengers:[\
		{id:"minecraft:block_display",Tags:["mot_mover_display","block_0","block"],CustomName:'"mot_mover_block_0"',transformation:{right_rotation:[0f,0f,0f,1f],scale:[1f,1f,1f],left_rotation:[0f,0f,0f,1f],translation:[-0.5f,-1.125f,-0.5f]},interpolation_duration:1}\
	]\
}
execute as @e[tag=result,limit=1] on passengers run function mot_uav:set_uvw
execute as @e[tag=result,limit=1] run function mot_mover:set
execute as @e[tag=result,limit=1] run function mot_mover:set_operations
```

打开mot_mover下的mot终端，创建set_operations

```
cre set_operations
```

编写set_operations

```
#mot_mover:set_operations
# mot_mover:_new调用

# 获取设备编号
function mot_uav:_new_id
scoreboard players operation @s mot_uav_id = res int

# 获取模块编号
scoreboard players operation @s module_id = #mot_mover: module_id
```

打开mot_mover下的mot终端，创建接口_class, _anchor_to, _zero, _model

然后创建一个异步测试项目命名为display

```
cre _class _anchor_to _zero _model
creisp test/display/start
```

实现_anchor_to接口，直接参照mot_uav:_anchor_to

```
#mot_mover:_anchor_to
# 输入执行坐标
# 输入执行朝向
# 需要传入世界实体为执行者

tp @s ~ ~ ~
data modify storage math:io xyz set from entity @s Pos
execute store result score x int run data get storage math:io xyz[0] 10000
execute store result score y int run data get storage math:io xyz[1] 10000
execute store result score z int run data get storage math:io xyz[2] 10000

function math:quat/_facing_to
function math:quat/_touvw

# 更新四元数旋转参数
function mot_uav:angular/_update
```

编写_class，生成测试数据模板

```
#mot_mover:_class
# 生成预设静态数据模板

# 生成测试数据模板
function mot_mover:_zero
execute positioned 8 -59 8 rotated 0.0 0.0 as @e[tag=math_marker,limit=1] run function mot_mover:_anchor_to
function mot_mover:_model
data modify storage mot_mover:class test set from storage mot_mover:io result
```

修改test/display/start

```
#mot_mover:test/display/start

# 生成测试程序实体
tag @e[tag=result] remove result
data modify storage mot_mover:io input set from storage mot_mover:class test
execute positioned 8 -59 8 run function mot_mover:_new

...

# 设置测试程序运行时间
scoreboard players set @e[tag=result,limit=1] killtime 10
scoreboard players set test int 0
```

修改test/display/end

```
#mot_mover:test/display/end

function mot_mover:_del
```

修改test/display/main

```
#mot_mover:test/display/main

# test置1结束测试
execute if score test int matches 1 run return fail

# 刷新存在时间
scoreboard players set @s killtime 10

# test置-1刷新实例
execute unless score test int matches -1 run return fail
scoreboard players set test int 0
execute as @e[tag=mot_mover] run function mot_mover:_del
function mot_mover:test/display/start
```

修改main

```
#mot_mover:main
# mot_mover:tick调用
# 实体对象主程序

function mot_mover:_get
function mot_mover:collision/_load_data

scoreboard players operation tempid int = @s mot_uav_root
execute if score tempid int matches 0 run function mot_uav:device/_main_motion
execute if score tempid int matches 1.. if function mot_mover:sync_uvw run function mot_uav:device/_main_sync
execute if entity @s[tag=triggered] run function mot_mover:_run

function mot_mover:_store

# 坐标安全
execute unless score y int matches -640000..5120000 run function mot_mover:_del
```

进入游戏运行测试

```
reload
function mot_mover:_init
```

放置循环命令方块运行tick

```
function mot_mover:tick
```

![alt text](images_part2/image-22.png)

聊天栏调用测试

```
scoreboard players set test int 1
function mot_mover:test/display/start
```

![alt text](images_part2/image-23.png)

然后创建搬运器设备的协议接口

打开mot_mover下的mot终端，创建_sync_request, _sync_coord, _use_signal

```
cre _sync_request _sync_coord _use_signal
```

```
#mot_mover:_sync_request

# 不支持左右插口
execute unless data storage mot_uav:io {slot_type:"down"} run return run scoreboard players set res int 0

# 采用默认实现
function mot_uav:device/_sync_request
```

```
#mot_mover:_sync_coord

# 采用默认实现
function mot_uav:device/_sync_coord
```

```
#mot_mover:_use_signal
# 输出<res,int>, 使用结束?1:0

scoreboard players set res int 1
tag @s add triggered
```

打开mot_mover下的mot终端，创建_run, sync_uvw

```
cre _run sync_uvw
```

实现sync_uvw

```
#mot_mover:sync_uvw
# mot_mover:main调用

scoreboard players set mot_sync_u int 0
scoreboard players set mot_sync_v int 1250
scoreboard players set mot_sync_w int 0

# 设置完成
return 1
```

打开mot_mover下的mot终端，创建block/_read, block/_place

```
cre block/_read block/_place
```

创建block/.doc.mcfo

```
#mot_mover:block/doc.mcfo

# 方块的临时对象
_this: {
	block_id:[storage mot_mover:io block_id,String],
	block_state:[storage mot_mover:io block_state,Compound],
	block_nbt:[storage mot_mover:io block_nbt,Compound]
}
```

编写block/_read

```
#mot_mover:block/_read
# 读取方块数据
# 输入执行位置

# 数据置空
data modify storage mot_mover:io block_id set value ""
data modify storage mot_mover:io block_state set value {}
data modify storage mot_mover:io block_nbt set value {}

# 决定读取哪些方块状态、是否读取NBT
scoreboard players set temp_state_0 int 0
scoreboard players set temp_state_1 int 0
scoreboard players set temp_nbt int 0
execute store result score res int run loot replace entity 0-0-0-0-2 container.0 mine ~ ~ ~ minecraft:golden_pickaxe[minecraft:enchantments={levels:{"minecraft:silk_touch":1}}]
execute if score res int matches 1 run data modify storage mot_mover:io block_id set from entity 0-0-0-0-2 item.id

# 加载特殊方块数据
data modify storage mot_mover:io func_name set string storage mot_mover:io block_id 10
function mot_mover:block/search with storage mot_mover:io {}

# 读取方块状态
execute if score temp_state_0 int matches 1 run function mot_mover:block/read_state_0
execute if score temp_state_1 int matches 1 run function mot_mover:block/read_state_1

# 读取NBT
execute if score temp_nbt int matches 1 run data modify storage mot_mover:io block_nbt set from block ~ ~ ~ {}
```

打开mot_mover下的mot终端，创建block/search, block/read_state_0, block/read_state_1, block/load/chest

```
cre block/search block/read_state_0 block/read_state_1 block/load/chest
```

编写block/search

```
#mot_mover:block/search
# mot_mover:block/_read调用

$function mot_mover:block/load/$(func_name)
```

编写block/load/chest

```
#mot_mover:block/load/chest
# mot_mover:block/search调用

scoreboard players set temp_state_0 int 1
scoreboard players set temp_state_1 int 1
scoreboard players set temp_nbt int 1
```

编写block/read_state_0

```
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
```

编写block/read_state_1

```
#mot_mover:block/read_state_1
# mot_mover:block/_read调用

# 读取type
execute if predicate {"condition":"location_check","predicate":{"block":{"state":{"type":"single"}}}} run \
	data modify storage mot_mover:io block_state.type set value "single"
execute if predicate {"condition":"location_check","predicate":{"block":{"state":{"type":"left"}}}} run \
	data modify storage mot_mover:io block_state.type set value "left"
execute if predicate {"condition":"location_check","predicate":{"block":{"state":{"type":"right"}}}} run \
	data modify storage mot_mover:io block_state.type set value "right"
```

编写block/_place

```
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
```

打开mot_mover下的mot终端，创建block/state_string, block/string_loop, block/setblock

```
cre block/state_string block/string_loop block/setblock
```

编写block/state_string

```
#mot_mover:block/state_string
# mot_mover:block/_place调用

$data modify storage math:io input set value '$(block_state)'
```

编写block/string_loop

```
#mot_mover:block/string_loop
# mot_mover:block/_place调用

function perf:utils/string/_find
# 查找结束
execute if score res int matches 0 run return fail

# 冒号替换为等号
data modify storage math:io string_chars[0] set value {char:"="}

# 继续查找
function mot_mover:block/string_loop
```

编写block/setblock

```
#mot_mover:block/setblock
# mot_mover:block/_place调用

$setblock ~ ~ ~ $(block_id)$(state_string)
```

编写_run

```
#mot_mover:_run
# 运行搬运器

tag @s remove triggered

# 获取抓取点
scoreboard players set u int 0
scoreboard players set v int -1250
scoreboard players set w int 0
execute as 0-0-0-0-0 run function math:uvw/_topos

# 选择分支
execute store result score temp_branch int unless data storage mot_mover:io {block_id:""}
execute if score temp_branch int matches 0 as 0-0-0-0-0 at @s run function mot_mover:grab_block
execute if score temp_branch int matches 1 as 0-0-0-0-0 at @s run function mot_mover:place_block

# 更新展示实体
function mot_mover:update_block
```

打开mot_mover下的mot终端，创建grab_block, place_block

```
cre grab_block place_block
```

编写grab_block

```
#mot_mover:grab_block
# mot_mover:_run调用

# 尝试读取方块
function mot_mover:block/_read
# 读取失败则直接返回
execute if data storage mot_mover:io {block_id:""} run return run playsound minecraft:block.iron_door.close player @a ~ ~ ~ 1.0 1.5

# 挖掘方块效果
data modify block ~ ~ ~ Items set value []
execute store result score temp int run gamerule doTileDrops
gamerule doTileDrops false
setblock ~ ~ ~ air destroy
execute if score temp int matches 1 run gamerule doTileDrops true
```

编写place_block

```
#mot_mover:place_block
# mot_mover:_run调用

# 无法放置方块
execute unless block ~ ~ ~ #mot_uav:pass run return run playsound minecraft:block.note_block.banjo player @a ~ ~ ~ 1.0 2.0

# 放置方块
playsound minecraft:block.stone.place player @a ~ ~ ~ 1.0 1.5
function mot_mover:block/_place
function mot_mover:block/_zero
```

修改set_operations

```
#mot_mover:set_operations
# mot_mover:_new调用

# 更新展示实体
function mot_mover:block/_get
function mot_mover:update_block

# 获取设备编号
function mot_uav:_new_id
scoreboard players operation @s mot_uav_id = res int

# 获取模块编号
scoreboard players operation @s module_id = #mot_mover: module_id
```

打开mot_mover下的mot_终端，创建update_block, block/_zero, block/_get

```
cre update_block block/_zero block/_get
```

编写update_block

```
#mot_mover:update_block
# mot_mover:grab_block调用
# mot_mover:place_block调用
# mot_mover:set_operations调用

data modify storage mot_mover:io temp set value {}
data modify storage mot_mover:io temp.Name set from storage mot_mover:io block_id
data modify storage mot_mover:io temp.Properties set from storage mot_mover:io block_state
execute on passengers run data modify entity @s block_state set from storage mot_mover:io temp
```

编写block/_zero

```
#mot_mover:block/_zero
# 把临时对象置零

data modify storage mot_mover:io block_id set value ""
data modify storage mot_mover:io block_state set value {}
data modify storage mot_mover:io block_nbt set value {}
```

编写block/_get

```
#mot_mover:block/_get
# 数据临时化
# 以实例为执行者

data modify storage mot_mover:io block_id set from entity @s item.components."minecraft:custom_data".block_id
data modify storage mot_mover:io block_state set from entity @s item.components."minecraft:custom_data".block_state
data modify storage mot_mover:io block_nbt set from entity @s item.components."minecraft:custom_data".block_nbt
```

进入游戏运行测试

```
scoreboard players set test int 1
reload
function mot_mover:test/display/start
function mot_uav:test/general/start
execute as @e[tag=mot_uav,limit=1] run function mot_uav:_controller
```

![alt text](images_part2/image-24.png)

观察到无人机成功搬运箱子

### 3.2.5 添加栓绳船设备

回到data目录，创建新的命名空间mot_boat

在mot_boat/function下部署新的mot副本

**请注意.mot_memory不要复制已有模块下的文件，因为这会继承白名单设置**

![alt text](images_part2/image-25.png)

修改.mot_memory/objects/global_settings.mcfo

```
# 无需初始化/创建的数据位置
global_default: {
	positions: {
		<@s, x>, <@s, y>, <@s, z>,
		<@s, x, 1w>, <@s, y, 1w>, <@s, z, 1w>
	},
	caches: {
		[storage math:io xyz, ListDouble, 3],
		[storage math:io xyzw, ListFloat, 4],
		[storage math:io rec, ListCompound, 1],
		[storage math:io rotation, ListFloat, 2]
	}
}

# 整数常量
int_consts: {-1, 0, 1, 2, 3, 4, 5, 10, 100, 1000, 10000}

# 项目名称
project_name:mot_boat

# 实体对象的数据位置
entity_store_path:item.components."minecraft:custom_data"

# 实体对象的类型
entity_type:oak_boat

# 初始化模块时创建的接口
init_interfaces:{
	_get,_store,_new,set,_del,main,tick
}
```

编写.doc.mcfo

```
#mot_boat:doc.mcfo

# 临时对象
_this:{
	mot_uav_root:<mot_uav_root,int>
}
```

打开mot_boat下的mot终端，输入init命令，创建_init函数，初始化代码，并完成白名单设置

```
init
cre _init
sync
protect _init tick main _new _class _del
```

修改_init函数，完成模块注册

```
#mot_boat:_init
# 初始化mot_boat包

# 初始化模块控制
scoreboard objectives add int dummy
execute unless score module_control_inited int matches 1 run function module_control:_init

# 注册本模块
data modify storage module_control:io input set value {prefix:"mot_boat:",namespace:"mot_boat"}
function module_control:data/_reg
scoreboard players operation #mot_boat: module_id = res int

# 建立记分板
scoreboard objectives add mot_uav_root dummy

# 设置常量
function mot_boat:_consts

# 生成静态数据模板
function mot_boat:_class
```

修改_del函数

```
#mot_boat:_del
# 销毁实体对象
# 输入执行实体

data modify storage mot_uav:io free_addr prepend value 0
execute store result storage mot_uav:io free_addr[0] int 1 run scoreboard players get @s mot_uav_id

kill @s
```

修改_new函数

```
#mot_boat:_new
# 使用数据模板生成实体对象
# 输入数据模板storage mot_boat:io input
# 输入执行位置
# 输出 @e[tag=result,limit=1]

tag @e[tag=result] remove result
summon oak_boat ~ ~ ~ {Tags:["mot_boat", "result", "mot_device"]}
execute as @e[tag=result,limit=1] run function mot_boat:set
execute as @e[tag=result,limit=1] run function mot_boat:set_operations
```

打开mot_boat下的mot终端，创建set_operations

```
cre set_operations
```

编写set_operations

```
#mot_boat:set_operations
# mot_boat:_new调用

# 获取设备编号
function mot_uav:_new_id
scoreboard players operation @s mot_uav_id = res int

# 获取模块编号
scoreboard players operation @s module_id = #mot_boat: module_id
```

打开mot_boat下的mot终端，创建接口_class, _zero, _model

然后创建一个异步测试项目命名为display

```
cre _class _zero _model
creisp test/display/start
```

编写_class，生成测试数据模板

```
#mot_boat:_class
# 生成预设静态数据模板

# 生成测试数据模板
function mot_boat:_zero
function mot_boat:_model
data modify storage mot_boat:class test set from storage mot_boat:io result
```

修改test/display/start

```
#mot_boat:test/display/start

tag @e[tag=test] remove test
# 生成设备
data modify storage mot_boat:io input set from storage mot_boat:class test
execute positioned 8 -59 8 run function mot_boat:_new
tag @e[tag=result,limit=1] add test
# 生成测试程序实体
tag @e[tag=result] remove result
summon marker 0 0 0 {Tags:["test", "mot_boat_test", "result"], CustomName:'{"text":"mot_boat_test"}'}

execute as @e[tag=result,limit=1] run function marker_control:data/_get

# 设置测试程序主函数和销毁函数
data modify storage marker_control:io result.tick_func set value "mot_boat:test/display/main"
data modify storage marker_control:io result.del_func set value "mot_boat:test/display/end"

execute as @e[tag=result,limit=1] run function marker_control:data/_store
tag @e[tag=result,limit=1] add entity_ticked
tag @e[tag=result,limit=1] add entity_todel

# 设置测试程序运行时间
scoreboard players set @e[tag=result,limit=1] killtime 10
scoreboard players set test int 0
```

修改test/display/end

```
#mot_boat:test/display/end

execute as @e[tag=mot_boat,tag=test,limit=1] run function mot_boat:_del
```

修改test/display/main

```
#mot_boat:test/display/main

# test置1结束测试
execute if score test int matches 1 run return fail

# 刷新存在时间
scoreboard players set @s killtime 10

# test置-1刷新实例
execute unless score test int matches -1 run return fail
scoreboard players set test int 0
execute as @e[tag=mot_boat,tag=test,limit=1] run function mot_boat:_del
data modify storage mot_boat:io input set from storage mot_boat:class test
execute positioned 8 -59 8 run function mot_boat:_new
tag @e[tag=result,limit=1] add test
```

修改main

```
#mot_boat:main
# mot_boat:tick调用
# 实体对象主程序

function mot_boat:_get

scoreboard players operation tempid int = @s mot_uav_root
execute if score tempid int matches 0 run function mot_boat:main_motion
execute if score tempid int matches 1.. run function mot_boat:main_sync
execute if entity @s[tag=triggered] run function mot_boat:_run

function mot_boat:_store
```

进入游戏运行测试

```
reload
function mot_boat:_init
```

放置循环命令方块运行tick

```
function mot_boat:tick
```

聊天栏调用测试

```
scoreboard players set test int 1
function mot_boat:test/display/start
```

![alt text](images_part2/image-26.png)

然后创建船设备的协议接口

打开mot_boat下的mot终端，创建_sync_request, _sync_coord, _use_signal

```
cre _sync_request _sync_coord _use_signal
```

```
#mot_boat:_sync_request

# 不支持左右插口
execute unless data storage mot_uav:io {slot_type:"down"} run return run scoreboard players set res int 0

# 采用默认实现
function mot_uav:device/_sync_request

# 栓绳连接
scoreboard players operation tempid int = @s mot_uav_root
execute as @e[tag=mot_uav] if score @s mot_uav_id = tempid int run data modify storage mot_boat:io temp_uuid set from entity @s UUID
execute if score res int matches 1.. run data modify entity @s leash.UUID set from storage mot_boat:io temp_uuid
```

```
#mot_boat:_sync_coord
# 空实现
```

```
#mot_boat:_use_signal
# 输出<res,int>, 使用结束?1:0

scoreboard players set res int 1
tag @s add triggered
```

打开mot_boat下的mot终端，创建main_sync

```
cre main_sync
```

```
#mot_boat:main_sync
# mot_boat:main调用

# 连接确认
scoreboard players set res int 0
execute as @e[tag=mot_device] if score @s mot_uav_id = mot_uav_root int run function module_control:_call_method {path:"_get_slot_id"}
execute unless score res int = @s mot_uav_id run return run function mot_boat:deconnect

# 栓绳确认
execute if data entity @s leash run return fail
execute at @s run kill @e[type=item,nbt={Item:{id:"minecraft:lead"}},limit=1,sort=nearest]
function mot_boat:deconnect
```

创建deconnect

```
cre deconnect
```

```
#mot_boat:deconnect
# mot_boat:main_sync调用

scoreboard players set mot_uav_root int 0
data remove entity @s leash
```

进入游戏运行测试

```
scoreboard players set test int 1
reload
function mot_boat:test/display/start
function mot_uav:test/general/start
execute as @e[tag=mot_uav,limit=1] run function mot_uav:_controller
```

![alt text](images_part2/image-27.png)

栓绳船连接成功

发现断连后栓绳仍然渲染的bug

为了解决这个bug，我们关闭循环命令方块

![alt text](images_part2/image-34.png)

修改_init，改用tick.json调用tick函数

```
#mot_boat:_init
# 初始化mot_boat包

# 调用tick函数
kill @e[tag=mot_boat_tick]
summon marker 0 0 0 {Tags:["mot_boat_tick"],CustomName:'"mot_boat_tick"'}
execute as @e[tag=mot_boat_tick,limit=1] run function marker_control:data/_get
data modify storage marker_control:io result.tick_func set value "mot_boat:tick"
execute as @e[tag=mot_boat_tick,limit=1] run function marker_control:data/_store
tag @e[tag=mot_boat_tick,limit=1] add entity_ticked

...
```

进入游戏重新运行初始化

```
scoreboard players set test int 1
reload
function mot_boat:_init
```

### 3.2.6 添加投弹设备

回到data目录，创建新的命名空间mot_dropper

直接复制mot_mover中的所有文件到mot_dropper之下

但是我们要删掉mot_dropper下的block子模块，因为可以复用原模块

![alt text](images_part2/image-28.png)

修改.mot_memory/objects/global_settings.mcfo，将"mot_mover"替换为"mot_dropper"

修改.doc.mcfo，将第一处"mot_mover"替换为"mot_dropper"，而block_plate中"mot_mover"仍要保留

打开所有函数，将"mot_mover"全局替换为"mot_dropper"

但以下接口中block_id, block_state, block_nbt的"mot_mover"命名空间仍然保留：

_get, _store, _model, _zero

```
#mot_dropper:_get
# 实体对象赋值到临时对象
# 输入执行实体

data modify storage mot_mover:io block_id set from entity @s item.components."minecraft:custom_data".block_id
data modify storage mot_mover:io block_state set from entity @s item.components."minecraft:custom_data".block_state
data modify storage mot_mover:io block_nbt set from entity @s item.components."minecraft:custom_data".block_nbt
...
```

```
#mot_dropper:_store
# 临时对象赋值到实体对象
# 输入执行实体

data modify entity @s item.components."minecraft:custom_data".block_id set from storage mot_mover:io block_id
data modify entity @s item.components."minecraft:custom_data".block_state set from storage mot_mover:io block_state
data modify entity @s item.components."minecraft:custom_data".block_nbt set from storage mot_mover:io block_nbt
...
```

```
#mot_dropper:_model
...

data modify storage mot_dropper:io result.block_id set from storage mot_mover:io block_id
data modify storage mot_dropper:io result.block_state set from storage mot_mover:io block_state
data modify storage mot_dropper:io result.block_nbt set from storage mot_mover:io block_nbt
...
```

```
#mot_dropper:_zero
# 把临时对象的全部数据置0

data modify storage mot_mover:io block_id set value ""
data modify storage mot_mover:io block_state set value {}
data modify storage mot_mover:io block_nbt set value {}
...
```

以下函数中对block子模块调用的"mot_mover"命名空间仍然保留：

_run, grab_block, place_block, update_block, set_operations, collision/_load_data

```
#mot_dropper:_run
# 运行搬运器

...

# 选择分支
execute store result score temp_branch int unless data storage mot_mover:io {block_id:""}
...
```

```
#mot_dropper:grab_block
# mot_dropper:_run调用

# 尝试读取方块
function mot_mover:block/_read
# 读取失败则直接返回
execute if data storage mot_mover:io {block_id:""} run playsound minecraft:block.iron_door.close player @a ~ ~ ~ 1.0 1.5

...
```

```
#mot_dropper:place_block
# mot_dropper:_run调用

...

# 放置方块
playsound minecraft:block.stone.place player @a ~ ~ ~ 1.0 1.5
function mot_mover:block/_place
function mot_mover:block/_zero
```

```
#mot_dropper:update_block
# mot_dropper:grab_block调用
# mot_dropper:place_block调用
# mot_dropper:set_operations调用

data modify storage mot_dropper:io temp set value {}
data modify storage mot_dropper:io temp.Name set from storage mot_mover:io block_id
data modify storage mot_dropper:io temp.Properties set from storage mot_mover:io block_state
execute on passengers run data modify entity @s block_state set from storage mot_dropper:io temp
```

```
#mot_dropper:set_operations
# mot_dropper:_new调用

# 更新展示实体
function mot_mover:block/_get
function mot_dropper:update_block

...
```

```
#mot_dropper:collision/_load_data
# 加载搬运器碰撞数据

# 碰撞点列表
data modify storage mot_uav:io collision_points set value [\
	[-0.125d, -0.125d, -0.125d],\
	[-0.125d, -0.125d, 0.125d],\
	[-0.125d, 0.125d, -0.125d],\
	[-0.125d, 0.125d, 0.125d],\
	[0.125d, -0.125d, -0.125d],\
	[0.125d, -0.125d, 0.125d],\
	[0.125d, 0.125d, -0.125d],\
	[0.125d, 0.125d, 0.125d]\
]

scoreboard players set mot_uav_ch int 1250

execute unless data storage mot_mover:io {block_id:""} run \
	data modify storage mot_uav:io collision_points set value [\
	[-0.5d, -1.125d, -0.5d],\
	[-0.5d, -1.125d, 0.5d],\
	[-0.5d, -0.125d, -0.5d],\
	[-0.5d, -0.125d, 0.5d],\
	[0.5d, -1.125d, -0.5d],\
	[0.5d, -1.125d, 0.5d],\
	[0.5d, -0.125d, -0.5d],\
	[0.5d, -0.125d, 0.5d]\
]

execute unless data storage mot_mover:io {block_id:""} run \
	scoreboard players set mot_uav_ch int 11250

# 是否加载完成
return 1
```

修改grab_block，过滤非tnt方块

```
#mot_dropper:grab_block
# mot_dropper:_run调用

# 尝试读取方块
function mot_mover:block/_read
# 如果不是tnt方块则读取失败
execute unless data storage mot_mover:io {block_id:"minecraft:tnt"} run function mot_mover:block/_zero
# 读取失败则直接返回
execute if data storage mot_mover:io {block_id:""} run return run playsound minecraft:block.iron_door.close player @a ~ ~ ~ 1.0 1.5

...
```

修改place_block，放置方块行为改成投弹

```
#mot_dropper:place_block
# mot_dropper:_run调用

# 投弹
playsound minecraft:entity.tnt.primed player @a ~ ~ ~ 1.0 1.0

summon tnt ~ ~-0.5 ~ {fuse:60s}
function mot_mover:block/_zero
```

进入游戏运行测试

```
scoreboard players set test int 1
reload
function mot_dropper:_init
```

放置循环命令方块运行tick

```
function mot_dropper:tick
```

![alt text](images_part2/image-29.png)

聊天栏调用测试

```
function mot_dropper:test/display/start
function mot_uav:test/general/start
execute as @e[tag=mot_uav,limit=1] run function mot_uav:_controller
```

![alt text](images_part2/image-30.png)

观察到无人机成功投弹

## 第三节：设备应用实例

### 3.3.1 设备展览场景

回到data目录，创建新的命名空间mot_scenes，然后创建function文件夹

放入.mot.py和.doc.mcfo

function文件夹下创建program模块，用于存放应用场景专用程序

将mot_uav:program/forward, mot_uav:program/position, mot_uav:program/rotation, mot_uav:program/turn, mot_uav:program/facing, mot_uav:program/waiting, mot_uav:program/init复制进来

![alt text](images_part2/image-33.png)

修改program/init

```
#mot_scenes:program/init

# 预设控制程序的数据模板
data modify storage mot_scenes:class default_programs set value [\
	{id:"waiting", pointer:"mot_scenes:program/waiting", state:0, wait_time:-1},\
	{id:"rotation", pointer:"mot_scenes:program/rotation", target_y:0.0d, target_theta:0.0d, damp_params:[0.0095d,0.01d,0.08d], state:0},\
	{id:"position", pointer:"mot_scenes:program/position", target_y:0.0d, target_pos:[0.0d,0.0d,0.0d], damp_params:[0.95d,1.0d,0.008d], state:0},\
	{id:"turn", pointer:"mot_scenes:program/turn", delta_theta:0.0d, target_y:0.0d, target_theta:0.0d, damp_params:[0.0095d,0.01d,0.08d], state:0},\
	{id:"forward", pointer:"mot_scenes:program/forward", u:0.0d, v:0.0d, w:0.0d, target_y:0.0d, target_pos:[0.0d,0.0d,0.0d], damp_params:[0.95d,1.0d,0.008d], state:0},\
	{id:"facing", pointer:"mot_scenes:program/facing", target_y:0.0d, facing_pos:[0.0d,0.0d,0.0d], damp_params:[0.0095d,0.01d,0.08d], state:0}\
]
```

修改position, rotation, facing, waiting程序的_run函数，删去维持高度的部分（其它部分全都不用改）

```
#mot_scenes:program/position/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 获取水平偏移
scoreboard players operation damp_x int = x int
scoreboard players operation damp_z int = z int
scoreboard players operation damp_x int -= target_x int
scoreboard players operation damp_z int -= target_z int
scoreboard players set damp_y int 0

# 获取水平速度
scoreboard players operation damp_vx int = vx int
scoreboard players operation damp_vz int = vz int
scoreboard players set damp_vy int 0

scoreboard players operation temp_sf int = damp_f int
# 设置阻尼冲量参数
scoreboard players operation temp_r int = damp_x int
scoreboard players operation temp_r int /= 100 int
scoreboard players operation temp_r int *= temp_r int
scoreboard players operation sqrt int = damp_z int
scoreboard players operation sqrt int /= 100 int
scoreboard players operation sqrt int *= sqrt int
scoreboard players operation sqrt int += temp_r int
function math:sqrt/_self
scoreboard players operation sqrt int /= 4 int
scoreboard players operation damp_f int < sqrt int
scoreboard players operation damp_f int > 10 int

# 控制迭代
function math:damp_vec/_iter

scoreboard players set state int 1
# 抵达判定
function math:damp_vec/_energy
scoreboard players operation temp_e int = res int
function math:damp_vec/_threshold
scoreboard players operation res int *= 25 int
execute if score temp_e int <= res int run scoreboard players set state int 2

# 根据速度差值施加冲量
execute if score temp_e int > res int run function mot_scenes:program/position/apply_impulse
scoreboard players operation damp_f int = temp_sf int
```

```
#mot_scenes:program/rotation/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

# 获取当前偏航角
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get kvec_x int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get kvec_z int
data modify entity @s Pos set from storage math:io xyz
execute positioned 0.0 0.0 0.0 facing entity @s feet run tp @s ~ ~ ~ ~ ~
execute store result score damp_x int run data get entity @s Rotation[0] -10000

# 选取劣弧作为转动路径
scoreboard players operation damp_x int -= target_theta int
scoreboard players operation damp_x int %= 3600000 int
execute if score damp_x int matches 1800000.. run scoreboard players remove damp_x int 3600000

# 获取当前偏航角速度
scoreboard players operation damp_v int = angular_y int

# 阻尼迭代
function math:damp/_iter

scoreboard players set state int 1
# 判定阻尼运动终止
function math:damp/_energy
scoreboard players operation temp_e int = res int
function math:damp/_threshold
scoreboard players operation res int *= 10 int
execute if score temp_e int <= res int run scoreboard players set state int 2
execute if score temp_e int <= res int run scoreboard players set damp_v int 0

# 更新角速度
scoreboard players operation angular_y int = damp_v int
function mot_uav:angular/_update
```

```
#mot_scenes:program/facing/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

scoreboard players operation sstemp_vx int = vec_x int
scoreboard players operation sstemp_vy int = vec_y int
scoreboard players operation sstemp_vz int = vec_z int
scoreboard players operation vec_x int -= x int
scoreboard players operation vec_y int -= y int
scoreboard players operation vec_z int -= z int
function math:vec/_unit_xz
scoreboard players operation uvec_y int > -3333 int
scoreboard players operation uvec_y int < 3333 int
execute store result storage math:io xyz[0] double 0.0001 run scoreboard players get uvec_x int
execute store result storage math:io xyz[1] double 0.0001 run scoreboard players get uvec_y int
execute store result storage math:io xyz[2] double 0.0001 run scoreboard players get uvec_z int
data modify entity @s Pos set from storage math:io xyz
execute positioned 0.0 0.0 0.0 facing entity @s feet run function math:iquat/_facing_to

# 计算转轴和角度差
scoreboard players operation quat_x int *= -1 int
scoreboard players operation quat_y int *= -1 int
scoreboard players operation quat_z int *= -1 int
function math:quat/_mult
scoreboard players operation quat_x int *= -1 int
scoreboard players operation quat_y int *= -1 int
scoreboard players operation quat_z int *= -1 int
execute if score rquat_w int matches ..-1 run function math:rquat/_neg
function math:rquat/_touvec
scoreboard players operation res int *= -2 int
scoreboard players add res int 10000
scoreboard players operation cos int = res int
function math:_arccos
scoreboard players operation damp_x int = theta int
scoreboard players operation damp_x int *= -1 int

# 计算当前角速度沿转轴分量
scoreboard players operation damp_v int = angular_x int
scoreboard players operation damp_v int *= uvec_x int
scoreboard players operation temp int = angular_y int
scoreboard players operation temp int *= uvec_y int
scoreboard players operation damp_v int += temp int
scoreboard players operation temp int = angular_z int
scoreboard players operation temp int *= uvec_z int
scoreboard players operation damp_v int += temp int
scoreboard players operation damp_v int /= 10000 int

# 阻尼迭代
function math:damp/_iter

scoreboard players set state int 1
# 判定阻尼运动终止
function math:damp/_energy
scoreboard players operation temp_e int = res int
function math:damp/_threshold
scoreboard players operation res int *= 10 int
execute if score temp_e int <= res int run scoreboard players set state int 2
execute if score temp_e int <= res int run scoreboard players set damp_v int 0

# 更新角速度
scoreboard players operation angular_x int = uvec_x int
scoreboard players operation angular_y int = uvec_y int
scoreboard players operation angular_z int = uvec_z int
scoreboard players operation angular_x int *= damp_v int
scoreboard players operation angular_y int *= damp_v int
scoreboard players operation angular_z int *= damp_v int
scoreboard players operation angular_x int /= 10000 int
scoreboard players operation angular_y int /= 10000 int
scoreboard players operation angular_z int /= 10000 int
function mot_uav:angular/_update

scoreboard players operation vec_x int = sstemp_vx int
scoreboard players operation vec_y int = sstemp_vy int
scoreboard players operation vec_z int = sstemp_vz int
```

```
#mot_scenes:program/waiting/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

scoreboard players set state int 1
execute if score wait_time int matches 1.. run scoreboard players remove wait_time int 1
execute if score wait_time int matches 0 run scoreboard players set state int 2
```

修改turn, forward程序的_run函数，更改转存程序指针（其它部分全都不用改）

```
#mot_scenes:program/turn/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

scoreboard players set state int 1

# 计算target_theta
function mot_uav:_get_theta
scoreboard players operation target_theta int = theta int
scoreboard players operation target_theta int += delta_theta int

# 转存为rotation程序
data modify storage mot_uav:io ptr set value "mot_scenes:program/rotation"
```

```
#mot_scenes:program/forward/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

scoreboard players set state int 1

# 计算target_pos
function math:uvw/_tovec
scoreboard players operation target_x int = vec_x int
scoreboard players operation target_z int = vec_z int

# 转存为position程序
data modify storage mot_uav:io ptr set value "mot_scenes:program/position"
```


function文件夹下创建exhibition场景

打开mot终端，创建exhibition/start, exhibition/main, exhibition/end

```
cre exhibition/start exhibition/main exhibition/end
```

编写exhibition/start

```
#mot_scenes:exhibition/start
# 聊天栏调用

tag @e[tag=test] remove test

# 初始化控制程序模板
function mot_scenes:program/init

# 状态列表
data modify storage mot_scenes:io list_states set value [\
	{state:"moving", target_pos:[20.5d,-58.5d,-5.0d],target_theta:-90.0f},\
	{state:"moving", target_pos:[20.5d,-59.5d,-5.0d],target_theta:-90.0f},\
	{state:"connecting", slot:"right"},\
	{state:"waiting", wait_time:20},\
	{state:"using", use_cnt:1, slot:"right"},\
	{state:"waiting", wait_time:40},\
	{state:"moving", target_pos:[20.5d,-59.5d,-3.5d],target_theta:-90.0f},\
	{state:"connecting", slot:"left"},\
	{state:"waiting", wait_time:20},\
	{state:"using", use_cnt:20, slot:"left"},\
	{state:"moving", target_pos:[20.5d,-56.5d,-3.5d],target_theta:-45.0f},\
	{state:"using", use_cnt:20, slot:"left"},\
	{state:"moving", target_pos:[20.5d,-56.5d,-3.5d],target_theta:-67.5f},\
	{state:"using", use_cnt:40, slot:"left"},\
	{state:"moving", target_pos:[20.5d,-59.0d,-3.5d],target_theta:-45.0f},\
	{state:"using", use_cnt:1, slot:"right"},\
	{state:"deconnecting", slot:"right"},\
	{state:"waiting", wait_time:20},\
	{state:"moving", target_pos:[20.5d,-58.5d,1.0d],target_theta:-90.0f},\
	{state:"moving", target_pos:[20.5d,-59.5d,1.0d],target_theta:-90.0f},\
	{state:"connecting", slot:"right"},\
	{state:"waiting", wait_time:20},\
	{state:"using", use_cnt:1, slot:"right"},\
	{state:"moving", target_pos:[20.5d,-56.5d,1.0d],target_theta:-45.0f},\
	{state:"using", use_cnt:20, slot:"left"},\
	{state:"using", use_cnt:1, slot:"right"},\
	{state:"moving", target_pos:[20.5d,-56.5d,1.0d],target_theta:-22.5f},\
	{state:"using", use_cnt:1, slot:"right"},\
	{state:"waiting", wait_time:20},\
	{state:"using", use_cnt:1, slot:"right"},\
	{state:"waiting", wait_time:20},\
	{state:"using", use_cnt:1, slot:"right"},\
	{state:"waiting", wait_time:10},\
	{state:"moving", target_pos:[20.5d,-58.5d,3.5d],target_theta:-90.0f},\
	{state:"moving", target_pos:[20.5d,-59.5d,3.5d],target_theta:-90.0f},\
	{state:"connecting", slot:"down"},\
	{state:"waiting", wait_time:20},\
	{state:"moving", target_pos:[17.5d,-58.5d,3.5d],target_theta:-90.0f},\
	{state:"using", use_cnt:1, slot:"down"},\
	{state:"moving", target_pos:[14.5d,-57.5d,3.5d],target_theta:-90.0f},\
	{state:"moving", target_pos:[14.5d,-58.5d,3.5d],target_theta:-90.0f},\
	{state:"using", use_cnt:1, slot:"down"},\
	{state:"moving", target_pos:[14.5d,-57.5d,3.5d],target_theta:-90.0f},\
	{state:"waiting", wait_time:40},\
	{state:"moving", target_pos:[14.5d,-58.5d,3.5d],target_theta:-90.0f},\
	{state:"using", use_cnt:1, slot:"down"},\
	{state:"moving", target_pos:[17.5d,-57.5d,3.5d],target_theta:-45.0f},\
	{state:"deconnecting", slot:"down"},\
	{state:"waiting", wait_time:20},\
	{state:"moving", target_pos:[20.5d,-58.5d,6.5d],target_theta:-90.0f},\
	{state:"moving", target_pos:[20.5d,-59.0d,6.5d],target_theta:-90.0f},\
	{state:"connecting", slot:"down"},\
	{state:"moving", target_pos:[20.5d,-50.0d,6.5d],target_theta:-90.0f},\
	{state:"moving", target_pos:[12.5d,-50.0d,6.5d],target_theta:-45.0f},\
	{state:"deconnecting", slot:"down"},\
	{state:"waiting", wait_time:20},\
	{state:"moving", target_pos:[20.5d,-58.5d,9.5d],target_theta:-90.0f},\
	{state:"moving", target_pos:[20.5d,-59.5d,9.5d],target_theta:-90.0f},\
	{state:"connecting", slot:"down"},\
	{state:"waiting", wait_time:20},\
	{state:"moving", target_pos:[17.5d,-58.5d,9.5d],target_theta:-90.0f},\
	{state:"using", use_cnt:1, slot:"down"},\
	{state:"moving", target_pos:[13.5d,-52.0d,16.5d],target_theta:-90.0f},\
	{state:"using", use_cnt:1, slot:"down"},\
	{state:"waiting", wait_time:80},\
	{state:"moving", target_pos:[20.5d,-58.5d,9.5d],target_theta:-90.0f},\
	{state:"deconnecting", slot:"left"},\
	{state:"waiting", wait_time:10},\
	{state:"deconnecting", slot:"down"},\
	{state:"waiting", wait_time:10},\
	{state:"deconnecting", slot:"right"},\
	{state:"waiting", wait_time:10},\
	{state:"waiting", wait_time:60}\
]

# 生成展览设备

# 测试红石灯
function mot_lamp:_zero
execute positioned 20 -58 -6 rotated 90.0 0.0 as @e[tag=math_marker,limit=1] run function mot_lamp:_anchor_to
function mot_lamp:_model
data modify storage mot_lamp:io input set from storage mot_lamp:io result
function mot_lamp:_new
tag @e[tag=result,limit=1] add test

# 机枪
function mot_scatter:_zero
execute positioned 20 -58 -3 rotated 90.0 0.0 as @e[tag=math_marker,limit=1] run function mot_scatter:_anchor_to
function mot_scatter:_model
data modify storage mot_scatter:io input set from storage mot_scatter:io result
function mot_scatter:_new
tag @e[tag=result,limit=1] add test

# 激光枪
function mot_laser:_zero
execute positioned 20 -58 0 rotated 90.0 0.0 as @e[tag=math_marker,limit=1] run function mot_laser:_anchor_to
function mot_laser:_model
data modify storage mot_laser:io input set from storage mot_laser:io result
function mot_laser:_new
tag @e[tag=result,limit=1] add test

# 方块搬运器
function mot_mover:_zero
execute positioned 20 -58 3 rotated 90.0 0.0 as @e[tag=math_marker,limit=1] run function mot_mover:_anchor_to
function mot_mover:_model
data modify storage mot_mover:io input set from storage mot_mover:io result
function mot_mover:_new
tag @e[tag=result,limit=1] add test

# 栓绳船
data modify storage mot_boat:io input set from storage mot_boat:class test
execute positioned 20 -58 6 run function mot_boat:_new
tag @e[tag=result,limit=1] add test

# 投弹器
function mot_dropper:_zero
execute positioned 20 -58 9 rotated 90.0 0.0 as @e[tag=math_marker,limit=1] run function mot_dropper:_anchor_to
function mot_dropper:_model
data modify storage mot_dropper:io input set from storage mot_dropper:io result
function mot_dropper:_new
tag @e[tag=result,limit=1] add test

# 生成无人机
function mot_uav:_zero
execute positioned 23 -58 -6 rotated 90.0 0.0 as @e[tag=math_marker,limit=1] run function mot_uav:_anchor_to
function mot_uav:_model
data modify storage mot_uav:io input set from storage mot_uav:io result
function mot_uav:_new
tag @e[tag=result,limit=1] add test

# 生成测试方块
setblock 17 -60 3 minecraft:chest[facing=west,type=single,waterlogged=false]{Items:[{Slot:0b,count:64,id:"minecraft:oak_log"},{Slot:1b,count:64,id:"minecraft:light_blue_concrete"}]}
setblock 17 -60 9 minecraft:tnt[unstable=false]
setblock 10 -59 17 minecraft:obsidian
setblock 10 -59 16 minecraft:obsidian
setblock 10 -59 15 minecraft:obsidian
setblock 11 -59 14 minecraft:obsidian
setblock 12 -59 13 minecraft:obsidian
setblock 13 -59 13 minecraft:obsidian
setblock 14 -59 13 minecraft:obsidian
setblock 15 -59 14 minecraft:obsidian
setblock 16 -59 15 minecraft:obsidian
setblock 16 -59 16 minecraft:obsidian
setblock 16 -59 17 minecraft:obsidian
setblock 15 -59 18 minecraft:obsidian
setblock 14 -59 19 minecraft:obsidian
setblock 13 -59 19 minecraft:obsidian
setblock 12 -59 19 minecraft:obsidian
setblock 11 -59 18 minecraft:obsidian
fill 11 -60 18 15 -60 14 minecraft:obsidian

# 生成测试实例
tag @e[tag=result] remove result
summon marker 0 0 0 {Tags:["mot_scene","test","result"],CustomName:'"mot_scene"'}
execute as @e[tag=result,limit=1] run function marker_control:data/_get
data modify storage marker_control:io result.tick_func set value "mot_scenes:exhibition/main"
data modify storage marker_control:io result.del_func set value "mot_scenes:exhibition/end"
execute as @e[tag=result,limit=1] run function mot_scenes:exhibition/initing/enter
execute as @e[tag=result,limit=1] run function marker_control:data/_store
tag @e[tag=result,limit=1] add entity_ticked
tag @e[tag=result,limit=1] add entity_todel
scoreboard players set @e[tag=result,limit=1] killtime 10
scoreboard players set test int 0
```

编写exhibition/main

```
#mot_scenes:exhibition/main
# mot_scenes:exhibition/start异步调用

function marker_control:data/_get
data modify storage mot_scenes:io temp_state set from storage marker_control:io result.state
# 手动结束项目
execute if score test int matches 1 run return fail
# 结束状态提前返回
execute if data storage mot_scenes:io {temp_state:"end"} run return fail
# 刷新存在时间
scoreboard players set @s killtime 10

# 状态分支
execute if data storage mot_scenes:io {temp_state:"deconnecting"} run function mot_scenes:exhibition/deconnecting/main
execute if data storage mot_scenes:io {temp_state:"connecting"} run function mot_scenes:exhibition/connecting/main
execute if data storage mot_scenes:io {temp_state:"waiting"} run function mot_scenes:exhibition/waiting/main
execute if data storage mot_scenes:io {temp_state:"initing"} run function mot_scenes:exhibition/initing/main
execute if data storage mot_scenes:io {temp_state:"moving"} run function mot_scenes:exhibition/moving/main
execute if data storage mot_scenes:io {temp_state:"using"} run function mot_scenes:exhibition/using/main

function marker_control:data/_store
```

编写exhibition/end

```
#mot_scenes:exhibition/end
# mot_scenes:exhibition/start异步调用

# 销毁所有设备
execute as @e[tag=mot_device,tag=test] run function module_control:_call_method {path:"_del"}
```

打开mot终端，创建exhibition/next_state

```
cre exhibition/next_state
```

编写exhibition/next_state

```
#mot_scenes:exhibition/next_state
# mot_scenes:exhibition/$(state)/main调用

# 所有状态运行结束则提前返回
execute unless data storage mot_scenes:io list_states[0] run \
	return run data modify storage marker_control:io result.state set value "end"

# 状态切换
data modify storage mot_scenes:io input set from storage mot_scenes:io list_states[0]
data remove storage mot_scenes:io list_states[0]
function mot_scenes:exhibition/enter_state with storage mot_scenes:io input
```

打开mot终端，创建exhibition/enter_state

```
cre exhibition/enter_state
```

编写exhibition/enter_state

```
#mot_scenes:exhibition/enter_state
# mot_scenes:exhibition/next_state调用

$function mot_scenes:exhibition/$(state)/enter
```

打开mot终端，创建exhibition/initing/enter, exhibition/initing/main

```
cre exhibition/initing/enter exhibition/initing/main
```

编写exhibition/initing/enter

```
#mot_scenes:exhibition/initing/enter
# 进入初始化状态

# 打开机翼电机
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:fans/_on

# 上传高度程序
data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"up"}]
data modify storage mot_uav:io program.delta_y set value 2.0d
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_store_program

# 状态切换
data modify storage marker_control:io result.state set value "initing"
```

编写exhibition/initing/main

```
#mot_scenes:exhibition/initing/main
# mot_scenes:exhibition/main调用

# 检测当前程序运行状态
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_get_program
# 状态结束条件
execute if data storage mot_uav:io program{pointer:"mot_uav:program/height",state:2} run function mot_scenes:exhibition/next_state
```

打开mot终端，创建exhibition/moving/enter, exhibition/moving/main

```
cre exhibition/moving/enter exhibition/moving/main
```

编写exhibition/moving/enter

```
#mot_scenes:exhibition/moving/enter
# 进入运动状态

# 创建复合程序
data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"compose"}]

# 添加高度程序
scoreboard players operation temp_y int = @e[tag=test,tag=mot_uav,limit=1] y
execute if data storage mot_scenes:io input.target_pos \
	store result score temp_y int run \
	data get storage mot_scenes:io input.target_pos[1] 10000
data modify storage mot_uav:io program.list_programs append from storage mot_uav:class default_programs[{id:"height"}]
execute store result storage mot_uav:io program.list_programs[-1].target_y double 0.0001 run scoreboard players get temp_y int

# 添加水平位移程序
execute if data storage mot_scenes:io input.target_pos run function mot_scenes:exhibition/moving/append_position

# 添加水平旋转程序
execute if data storage mot_scenes:io input.target_theta run function mot_scenes:exhibition/moving/append_rotation

# 上传程序
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_store_program

# 状态切换
data modify storage marker_control:io result.state set value "moving"
```

编写exhibition/moving/main

```
#mot_scenes:exhibition/moving/enter
# mot_scenes:exhibition/main调用

# 检测当前程序运行状态
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_get_program
# 状态结束条件
execute unless data storage mot_uav:io program{state:1} run function mot_scenes:exhibition/next_state
```

打开mot终端，创建exhibition/moving/append_position, exhibition/moving/append_rotation

```
cre exhibition/moving/append_position exhibition/moving/append_rotation
```

编写exhibition/moving/append_position 

```
#mot_scenes:exhibition/moving/append_position
# mot_scenes:exhibition/moving/enter调用

data modify storage mot_uav:io program.list_programs append from storage mot_scenes:class default_programs[{id:"position"}]
data modify storage mot_uav:io program.list_programs[-1].target_pos set from storage mot_scenes:io input.target_pos
```

编写exhibition/moving/append_rotation

```
#mot_scenes:exhibition/moving/append_rotation
# mot_scenes:exhibition/moving/enter调用

data modify storage mot_uav:io program.list_programs append from storage mot_scenes:class default_programs[{id:"rotation"}]
data modify storage mot_uav:io program.list_programs[-1].target_theta set from storage mot_scenes:io input.target_theta
```

打开mot终端，创建exhibition/waiting/enter, exhibition/waiting/main

```
cre exhibition/waiting/enter exhibition/waiting/main
```

编写exhibition/waiting/enter

```
#mot_scenes:exhibition/waiting/enter
# 进入等待状态

# 创建复合程序
data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"compose"}]

# 添加高度程序
scoreboard players operation temp_y int = @e[tag=test,tag=mot_uav,limit=1] y
execute if data storage mot_scenes:io input.target_pos \
	store result score temp_y int run \
	data get storage mot_scenes:io input.target_pos[1] 10000
data modify storage mot_uav:io program.list_programs append from storage mot_uav:class default_programs[{id:"height"}]
execute store result storage mot_uav:io program.list_programs[-1].target_y double 0.0001 run scoreboard players get temp_y int

# 添加水平位移程序
execute if data storage mot_scenes:io input.target_pos run function mot_scenes:exhibition/moving/append_position

# 添加等待程序
data modify storage mot_uav:io program.list_programs append from storage mot_scenes:class default_programs[{id:"waiting"}]
data modify storage mot_uav:io program.list_programs[-1].wait_time set from storage mot_scenes:io input.wait_time

# 上传程序
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_store_program

# 状态切换
data modify storage marker_control:io result.state set value "waiting"
```

编写exhibition/waiting/main

```
#mot_scenes:exhibition/waiting/main
# mot_scenes:exhibition/main调用

# 检测当前程序运行状态
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_get_program
# 状态结束条件
data modify storage mot_scenes:io temp set from storage mot_uav:io program.list_programs[-1].state
execute if data storage mot_scenes:io {temp:2} run function mot_scenes:exhibition/next_state
```

打开mot终端，创建exhibition/connecting/enter, exhibition/connecting/main

```
cre exhibition/connecting/enter exhibition/connecting/main
```

修改mot_uav:program/left_connect/_run, mot_uav:program/right_connect/_run, mot_uav:program/down_connect/_run

```
#mot_uav:program/left_connect/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

...

# 连接程序结束
scoreboard players set state int 2
execute if score inp int matches 0 run scoreboard players set state int -1

...
```

```
#mot_uav:program/right_connect/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

...

# 连接程序结束
scoreboard players set state int 2
execute if score inp int matches 0 run scoreboard players set state int -1

...
```

```
#mot_uav:program/down_connect/_run
# 输入mot_uav临时对象
# 输出mot_uav临时对象

...

# 连接程序结束
scoreboard players set state int 2
execute if score inp int matches 0 run scoreboard players set state int -1

...
```

编写exhibition/connecting/enter

```
#mot_scenes:exhibition/connecting/enter
# 进入连接状态

# 上传连接程序
execute if data storage mot_scenes:io input{slot:"left"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"left_connect"}]
execute if data storage mot_scenes:io input{slot:"right"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"right_connect"}]
execute if data storage mot_scenes:io input{slot:"down"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"down_connect"}]
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_store_program

# 状态切换
data modify storage marker_control:io result.state set value "connecting"
```

编写exhibition/connecting/main

```
#mot_scenes:exhibition/connecting/main
# mot_scenes:exhibition/main调用

# 连接成功则状态跳转
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_get_program
execute if data storage mot_uav:io program{state:2} run return run function mot_scenes:exhibition/next_state

# 尝试重新连接
data modify storage mot_uav:io program.state set value 1
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_store_program
```

打开mot终端，创建exhibition/deconnecting/enter, exhibition/deconnecting/main

```
cre exhibition/deconnecting/enter exhibition/deconnecting/main
```

编写exhibition/deconnecting/enter

```
#mot_scenes:exhibition/deconnecting/enter
# 进入断连状态

# 上传断连程序
execute if data storage mot_scenes:io input{slot:"left"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"left_deconnect"}]
execute if data storage mot_scenes:io input{slot:"right"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"right_deconnect"}]
execute if data storage mot_scenes:io input{slot:"down"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"down_deconnect"}]
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_store_program

# 状态切换
data modify storage marker_control:io result.state set value "deconnecting"
```

编写exhibition/deconnecting/main

```
#mot_scenes:exhibition/deconnecting/main
# mot_scenes:exhibition/main调用

# 直接状态跳转
function mot_scenes:exhibition/next_state
```

打开mot终端，创建exhibition/using/enter, exhibition/using/main

```
cre exhibition/using/enter exhibition/using/main
```

编写exhibition/using/enter

```
#mot_scenes:exhibition/using/enter
# 进入使用状态

# 上传使用程序
execute if data storage mot_scenes:io input{slot:"left"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"left_use"}]
execute if data storage mot_scenes:io input{slot:"right"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"right_use"}]
execute if data storage mot_scenes:io input{slot:"down"} run data modify storage mot_uav:io program set from storage mot_uav:class default_programs[{id:"down_use"}]
execute as @e[tag=test,tag=mot_uav,limit=1] run function mot_uav:_store_program

# 储存使用次数
data modify storage marker_control:io result.use_cnt set from storage mot_scenes:io input.use_cnt

# 状态切换
data modify storage marker_control:io result.state set value "using"
```

编写exhibition/using/main

```
#mot_scenes:exhibition/using/main
# mot_scenes:exhibition/main调用

# 检查使用次数
execute store result score temp_cnt int run data get storage marker_control:io result.use_cnt
execute store result storage marker_control:io result.use_cnt int 1 run scoreboard players remove temp_cnt int 1

# 继续使用设备
execute as @e[tag=mot_uav,limit=1] run function mot_uav:_get_program
data modify storage mot_uav:io program.state set value 1
execute if score temp_cnt int matches ..0 run data modify storage mot_uav:io program.state set value 2
execute as @e[tag=mot_uav,limit=1] run function mot_uav:_store_program

# 状态切换
execute if score temp_cnt int matches ..0 run function mot_scenes:exhibition/next_state
```

进入游戏运行测试

```
reload
function mot_scenes:exhibition/start
```

本教程完结