# Initial setup. Only run once when the datapack gets first added to a world
# Create scoreboard objectives, teams, etc here

from bolt_expressions import Scoreboard, Data

root = ctx.meta.namespace

# Set currently installe datapack version
data modify storage minecraft:ab.custom_stack_size version set value "1.0.1"

objectives = [
  "config",
  "__temp__"
]

for objective in objectives:
  if type(objective) is str:
    objective = [objective, "dummy"]
  
  if (type(objective) is list) and len(objective) == 1:
    objective.append("dummy")
  
  scoreboard objectives add f'{root}.{objective[0]}' objective[1]

  config = f"minecraft:{root}"
  stackSize = f"stack_size"
  unless data storage config stackSize run
    data modify storage config stackSize set value 99