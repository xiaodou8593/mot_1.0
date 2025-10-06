#mot_scatter:tick

execute if entity @e[tag=mot_scatter,limit=1] if function mot_scatter:collision/_load_data as @e[tag=mot_scatter] run function mot_scatter:main

execute as @e[tag=mot_scatter_bullet] at @s run function mot_scatter:bullet/main