#mot_laser:bullet/main
# mot_laser:tick调用

scoreboard players set res int 0
scoreboard players operation loop int = mot_laser_loop int
function mot_laser:bullet/loop