#mot_laser:tick

execute if entity @e[tag=mot_laser,limit=1] if function mot_laser:collision/_load_data as @e[tag=mot_laser] run function mot_laser:main

execute as @e[tag=mot_laser_bullet] at @s run function mot_laser:bullet/main