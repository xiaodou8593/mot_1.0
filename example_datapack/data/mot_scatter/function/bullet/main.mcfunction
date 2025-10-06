#mot_scatter:bullet/main
# mot_scatter:tick调用

scoreboard players set res int 0
scoreboard players operation loop int = mot_bullet_loop int
function mot_scatter:bullet/loop