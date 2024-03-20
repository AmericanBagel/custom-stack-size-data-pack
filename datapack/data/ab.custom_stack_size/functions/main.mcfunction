#> Main function
# Runs every tick
root = ctx.meta.namespace

import allay
parser = allay.Parser()
allayParse = parser.parse

# When data pack is initialized,
# ./load runs first.
append function ./load:
  say load
  # Check if datapack needs to be installed
  unless data storage minecraft:ab.custom_stack_size {"version": "0.1.0"} run function ./install

  #> Call main fn to avoid using #minecraft:tick
  # See https://github.com/LanternMC/load#avoiding-the-minecrafttick-tag
  schedule function ./main 1t
  for tick in tickFunctions:
    schedule function f'{root}:clock/{tick}t' f'{tick}t'

# Schedule function for next tick, to avoid using #minecraft:tick
schedule function ~/ 1t