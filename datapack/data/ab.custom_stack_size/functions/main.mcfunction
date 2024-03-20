#> Main function
# Runs every tick
root = ctx.meta.namespace

import allay

# When data pack is initialized,
# ./load runs first.
append function ./load:
  # Check if datapack needs to be installed
  unless data storage minecraft:ab.custom_stack_size {"version": "0.1.0"} run function ./install

  #> Call main fn to avoid using #minecraft:tick
  # See https://github.com/LanternMC/load#avoiding-the-minecrafttick-tag
  schedule function ./main 1t

config = f"minecraft:{root}"
stackSize = f"stack_size"

function ./set_item_entity_stack_size with storage config
function ./set_item_entity_stack_size:
  $execute as \
    @e[type=item,nbt=!{Item:{components:{"minecraft:max_stack_size":$(stack_size)}}}] \
    run data modify entity @s Item.components."minecraft:max_stack_size" \
    set value $(stack_size)
  # $say execute as @e[type=item,!nbt={Item:{components:{"minecraft:max_stack_size":$(stack_size)}}}] run say hi
  # $say $(stack_size)

execute as @a run function ./set_player_item_stack_size with storage config
function ./set_player_item_stack_size:
  $execute unless \
    items entity @s player.cursor *[minecraft:max_stack_size=$(stack_size)] \
    run item modify entity @s \
    player.cursor \
    [{"function":"minecraft:set_components","components":{"minecraft:max_stack_size":$(stack_size)}}]
  $execute unless \
    items entity @s weapon.mainhand *[minecraft:max_stack_size=$(stack_size)] \
    run item modify entity @s \
    weapon.mainhand \
    [{"function":"minecraft:set_components","components":{"minecraft:max_stack_size":$(stack_size)}}]
  $execute unless \
    items entity @s weapon.offhand *[minecraft:max_stack_size=$(stack_size)] \
    run item modify entity @s \
    weapon.offhand \
    [{"function":"minecraft:set_components","components":{"minecraft:max_stack_size":$(stack_size)}}]

  if entity @s[gamemode=creative] run function ~/creative with storage config:
    $execute unless items entity @s hotbar.0 *[minecraft:max_stack_size=$(stack_size)] run item modify entity @s hotbar.0 [{"function":"minecraft:set_components","components":{"minecraft:max_stack_size":$(stack_size)}}]
    $execute unless items entity @s hotbar.1 *[minecraft:max_stack_size=$(stack_size)] run item modify entity @s hotbar.1 [{"function":"minecraft:set_components","components":{"minecraft:max_stack_size":$(stack_size)}}]
    $execute unless items entity @s hotbar.2 *[minecraft:max_stack_size=$(stack_size)] run item modify entity @s hotbar.2 [{"function":"minecraft:set_components","components":{"minecraft:max_stack_size":$(stack_size)}}]
    $execute unless items entity @s hotbar.3 *[minecraft:max_stack_size=$(stack_size)] run item modify entity @s hotbar.3 [{"function":"minecraft:set_components","components":{"minecraft:max_stack_size":$(stack_size)}}]
    $execute unless items entity @s hotbar.4 *[minecraft:max_stack_size=$(stack_size)] run item modify entity @s hotbar.4 [{"function":"minecraft:set_components","components":{"minecraft:max_stack_size":$(stack_size)}}]
    $execute unless items entity @s hotbar.5 *[minecraft:max_stack_size=$(stack_size)] run item modify entity @s hotbar.5 [{"function":"minecraft:set_components","components":{"minecraft:max_stack_size":$(stack_size)}}]
    $execute unless items entity @s hotbar.6 *[minecraft:max_stack_size=$(stack_size)] run item modify entity @s hotbar.6 [{"function":"minecraft:set_components","components":{"minecraft:max_stack_size":$(stack_size)}}]
    $execute unless items entity @s hotbar.7 *[minecraft:max_stack_size=$(stack_size)] run item modify entity @s hotbar.7 [{"function":"minecraft:set_components","components":{"minecraft:max_stack_size":$(stack_size)}}]
    $execute unless items entity @s hotbar.8 *[minecraft:max_stack_size=$(stack_size)] run item modify entity @s hotbar.8 [{"function":"minecraft:set_components","components":{"minecraft:max_stack_size":$(stack_size)}}]

parser = allay.Parser(json_dump = False)
allayParse = parser.parse
from textwrap import dedent
function ./menu:
  message = allayParse(
    dedent(
    """
      @button = (color=dark_green)
      @primaryButton = (@button, color=green)
      @secondaryButton = (@button)
      #ALLAYDEFS
      [-------------------------------](color=blue,bold)




      [Stack size:](color=aqua) \
      [\\[✎\\]](@button, color=yellow, suggest="/data modify storage minecraft:ab.custom_stack_size stack_size set value 99") \
      [\\[⯬\\]](@secondaryButton, run="/function ab.custom_stack_size:menu/button/change_value {number:10,operation:'remove',eval:'function ab.custom_stack_size:menu'}") \
      [\\[←\\]](@primaryButton, run="/function ab.custom_stack_size:menu/button/change_value {number:1,operation:'remove',eval:'function ab.custom_stack_size:menu'}") \
      {nbt="%s", storage="%s"} \
      [\\[→\\]](@primaryButton, run="/function ab.custom_stack_size:menu/button/change_value {number:1,operation:'add',eval:'function ab.custom_stack_size:menu'}") \
      [\\[⯮\\]](@secondaryButton, run="/function ab.custom_stack_size:menu/button/change_value {number:10,operation:'add',eval:'function ab.custom_stack_size:menu'}")
    """
    % (stackSize, config)
  ))
  message[0] = "\n" * 20
  message.append ("\n" * 4)
  tellraw @s message

  function ~/button/change_value:
    temp = "ab.custom_stack_size.__temp__"
    execute store result score current temp run
      data get storage config stackSize
    $scoreboard players $(operation) current ab.custom_stack_size.__temp__ $(number)
    if score current temp matches 1..99:
      function ./menu/click_sound
    if score current temp matches ..0:
      function ./menu/error_sound
      scoreboard players set current temp 1
    if score current temp matches 99..:
      function ./menu/error_sound
      scoreboard players set current temp 99
    execute store result storage config stackSize int 1 run scoreboard players get current ab.custom_stack_size.__temp__
    $$(eval)

  function ~/click_sound:
    playsound minecraft:ui.button.click master @s ~ ~ ~ 0.2 1 1

  function ~/error_sound:
    playsound minecraft:block.note_block.bass master @s ~ ~ ~ 1 0.5
  
# Schedule function for next tick, to avoid using #minecraft:tick
schedule function ~/ 1t