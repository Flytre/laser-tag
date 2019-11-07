#Armor Stand Tags
#green_spawn, blue_spawn
#map_center
#shop
#lobby_start



function flytre:generic_base

scoreboard players add @a respawnTimer 0

scoreboard players set @a armor 0
execute as @a store result score @s armor3 run data get entity @s Inventory[{Slot:102b}].tag.armor
execute as @a run scoreboard players operation @s armor += @s armor3
execute as @a store result score @s armor3 run data get entity @s Inventory[{Slot:101b}].tag.armor
execute as @a run scoreboard players operation @s armor += @s armor3
execute as @a store result score @s armor3 run data get entity @s Inventory[{Slot:100b}].tag.armor
execute as @a run scoreboard players operation @s armor += @s armor3


bossbar set flytre:blue_score players @a
bossbar set flytre:green_score players @a


execute as @a[gamemode=spectator] at @s if block ~ ~ ~ cave_air run tp @s @e[tag=map_center,sort=nearest,limit=1]
execute as @a[team=green] at @s if block ~ ~ ~ cave_air run tp @s @e[tag=green_spawn,sort=nearest,limit=1]
execute as @a[team=blue] at @s if block ~ ~ ~ cave_air run tp @s @e[tag=blue_spawn,sort=nearest,limit=1]

effect give @a resistance 1 4 true
effect give @a night_vision 11 0 true


execute as @a[scores={respawnTimer=1..}] run scoreboard players remove @s respawnTimer 1
scoreboard players set @a[scores={respawnTimer=1..}] otherDamage 0
scoreboard players set @a[scores={respawnTimer=1..}] health 2000
execute as @a[scores={respawnTimer=1..}] at @s rotated ~ 0 run function flytre:particles/helix
scoreboard players set @a[scores={respawnTimer=1..}] armor 100

scoreboard players remove @a[tag=shot2] otherDamage 60
scoreboard players set five otherDamage 5

execute as @a[scores={otherDamage=1..},tag=!shot2] run scoreboard players operation @s otherDamage *= five otherDamage
execute as @a[scores={otherDamage=1..},tag=!shot2] run scoreboard players operation @s health -= @s otherDamage

scoreboard players set @a[x=-143,y=16,z=-65,dx=-5,dy=1,dz=3] rejoin 1
execute as @a[scores={rejoin=1..},team=] run tp @s @e[tag=map_center,sort=nearest,limit=1]
execute as @a[scores={rejoin=1..},team=] run effect clear @s
execute as @a[scores={rejoin=1..}] run effect give @s night_vision 1 0 true

execute as @a[scores={rejoin=1..},team=] run clear @s
execute as @a[scores={rejoin=1..},team=] run gamemode spectator @s

scoreboard players set @a[scores={rejoin=1..}] rejoin 0

function flytre:game_logic/player_count
execute store result score blue_score global run bossbar get flytre:blue_score value
execute store result score green_score global run bossbar get flytre:green_score value

#nearby icons
execute as @a[team=green] at @s if entity @a[team=blue,distance=..10] run effect give @s luck 100 0
execute as @a[team=blue] at @s if entity @a[team=green,distance=..10] run effect give @s luck 100 0
execute as @a[team=green] at @s unless entity @a[team=blue,distance=..10] run effect clear @s luck
execute as @a[team=blue] at @s unless entity @a[team=green,distance=..10] run effect clear @s luck


execute as @a[scores={health=..0},team=green] if score playing global matches 2..3 run scoreboard players add blue_score global 850
execute as @a[scores={health=..0},team=blue] if score playing global matches 2..3 run scoreboard players add green_score global 850
execute as @a[scores={health=..0},team=green] if score playing global matches 4..5 run scoreboard players add blue_score global 500
execute as @a[scores={health=..0},team=blue] if score playing global matches 4..5 run scoreboard players add green_score global 500
execute as @a[scores={health=..0},team=green] if score playing global matches 6..7 run scoreboard players add blue_score global 300
execute as @a[scores={health=..0},team=blue] if score playing global matches 6..7 run scoreboard players add green_score global 300
execute as @a[scores={health=..0},team=green] if score playing global matches 8..9 run scoreboard players add blue_score global 200
execute as @a[scores={health=..0},team=blue] if score playing global matches 8..9 run scoreboard players add green_score global 200
execute as @a[scores={health=..0},team=green] if score playing global matches 10.. run scoreboard players add blue_score global 150
execute as @a[scores={health=..0},team=blue] if score playing global matches 10.. run scoreboard players add green_score global 150

scoreboard players set @a[scores={health=..0}] kills2 0
scoreboard players set @a[scores={health=..0}] dash_cd 0
scoreboard players set @a[scores={health=..0}] blink_cd 0
scoreboard players set @a[scores={health=..0}] weak_heal_cd 0
scoreboard players set @a[scores={health=..0}] strong_heal_cd 0
scoreboard players set @a[scores={health=..0}] team_heal_cd 0
scoreboard players set @a[scores={health=..0}] spectral_eye_cd 0
effect clear @a[scores={health=..0}] glowing


execute as @a[scores={kills2=4..},tag=!quadKill] at @s run tellraw @a ["",{"text":"[","color":"green"},{"text":"Game","color":"none"},{"text":"]","color":"green"},{"text":":","color":"none"}, {"selector":"@a[scores={kills2=4..},tag=!quadKill,limit=1,sort=nearest]"}, {"text":" has gotten 4 ranged kills without dying! Their location is now revealed.","color":"gold"}]
effect give @a[scores={kills2=4..},tag=!quadKill] glowing 100 0 true
tag @a[scores={kills2=4..},tag=!quadKill] add quadKill


execute as @a[scores={otherDamage=1..}] at @s run execute at @a[scores={dd=0..},distance=..5,nbt={SelectedItem:{tag:{type:"saber"}}}] run playsound minecraft:flytre.saber.strike player @a ~ ~ ~ 15


execute as @a[scores={dd=0..},nbt={SelectedItem:{tag:{type:"saber"}}}] at @s if entity @a[scores={otherDamage=1..},distance=..5] run scoreboard players operation @s damage = @a[scores={otherDamage=1..},distance=..5] otherDamage
execute as @a[scores={dd=0..},nbt={SelectedItem:{tag:{type:"saber"}}}] at @s if entity @a[scores={otherDamage=1..},distance=..5] run function flytre:sync_xp

execute as @a[scores={health=..0,otherDamage=0},tag=!gun_death,tag=!quadKill] unless entity @a[scores={dd=0..},distance=..5] run tellraw @a ["",{"selector":"@s","color":"yellow"},{"text":" died.","color":"yellow"}]
execute as @a[scores={health=..0,otherDamage=1..},tag=!gun_death,tag=quadKill] at @s if entity @a[scores={dd=0..},distance=..5] run tellraw @a ["",{"selector":"@s","color":"yellow"},{"text":" lost their streak to ","color":"yellow"},{"selector":"@a[scores={dd=0..},distance=..5,limit=1]","color":"yellow"},{"text":".","color":"yellow"}]
execute as @a[scores={health=..0,otherDamage=1..},tag=!gun_death,tag=!quadKill] at @s if entity @a[scores={dd=0..},distance=..5] run tellraw @a ["",{"selector":"@s","color":"yellow"},{"text":" was melee'd by ","color":"yellow"},{"selector":"@a[scores={dd=0..},distance=..5,limit=1]","color":"yellow"},{"text":".","color":"yellow"}]
execute as @a[scores={health=..0,otherDamage=1..},tag=!gun_death,tag=!quadKill] at @s run scoreboard players add @a[scores={dd=0..},distance=..5,limit=1] kills 1

execute as @a[scores={health=..0}] at @s run particle minecraft:portal ~ ~ ~ 0.5 1 0.5 0 50

execute as @a[scores={health=..0},team=green] run tp @e[tag=green_spawn,sort=nearest,limit=1]
execute as @a[scores={health=..0},team=blue] run tp @e[tag=blue_spawn,sort=nearest,limit=1]

effect clear @a[scores={health=..0}] glowing

tag @a[scores={health=..0}] remove quadKill

execute as @a[scores={health=..0}] run scoreboard players set @s respawnTimer 60
scoreboard players set @a[scores={health=..0}] health 2000




function flytre:health

replaceitem entity @a[scores={sneak=0}] armor.head air
effect clear @a[scores={sneak=0}] minecraft:slowness

effect give @a[scores={sneak=1..},nbt={SelectedItem:{tag:{scope:1}}},gamemode=!spectator] slowness 1 5 true
replaceitem entity @a[scores={sneak=1..},nbt={SelectedItem:{tag:{scope:1}}},gamemode=!spectator] armor.head carved_pumpkin
scoreboard players set @a sneak 0

execute as @e[type=item] at @s run data merge entity @s {PickupDelay:0}

scoreboard players add healthSeconds global 1

execute if score healthSeconds global matches 20.. run scoreboard players add @a[nbt={SelectedItem:{tag:{type:"saber"}}}] health 10
execute if score healthSeconds global matches 20.. run scoreboard players set healthSeconds global 0


scoreboard players set @a otherDamage 0
scoreboard players set @a playerKills 0

scoreboard players reset @a killTracker

tag @a remove gun_death
tag @a[tag=shot2] remove shot2
tag @a[tag=shot] add shot2
tag @a remove shot


#idk if this is necessary
tag @a remove t_shotty

scoreboard players reset @a dd


function flytre:game_logic/player_count
execute store result bossbar flytre:blue_score value run scoreboard players get blue_score global
execute store result bossbar flytre:green_score value run scoreboard players get green_score global

execute if score players_blue global matches 0 run function flytre:game_logic/to_lobby
execute if score players_green global matches 0 run function flytre:game_logic/to_lobby
execute if score blue_score global matches 10000.. run function flytre:game_logic/to_lobby
execute if score green_score global matches 10000.. run function flytre:game_logic/to_lobby