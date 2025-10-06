#mot_uav:fans/run_program
# mot_uav:fans/main调用

data modify storage mot_uav:io input set from storage mot_uav:io program
$function $(pointer)/_proj
$function $(pointer)/_run
$function $(pointer)/_model
data modify storage mot_uav:io program set from storage mot_uav:io result