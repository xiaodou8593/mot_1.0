#mot_lamp:tick

execute if entity @e[tag=mot_lamp,limit=1] if function mot_lamp:collision/_load_data as @e[tag=mot_lamp] run function mot_lamp:main