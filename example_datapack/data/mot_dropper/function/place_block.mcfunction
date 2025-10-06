#mot_dropper:place_block
# mot_dropper:_run调用

# 投弹
playsound minecraft:entity.tnt.primed player @a ~ ~ ~ 1.0 1.0

summon tnt ~ ~-0.5 ~ {fuse:60s}
function mot_mover:block/_zero