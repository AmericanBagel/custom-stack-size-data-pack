# Unistall datapack
# Remove scoreboard objectives, teams, storage, etc here

tellraw @a[tag=!global.ignore,tag=!global.ignore.gui] ["",{"text":"Uninstalling ","color":"gold"},{"text":"Custom stack size for EVERYTHING ","color":"red"}, {"storage": "ab.custom_stack_size", "nbt": "version", "color":"red"}]

# Remove advancements
advancement revoke @a from americanbagel:ab.custom_stack_size/root

# Remove version
data remove storage minecraft:ab.custom_stack_size version