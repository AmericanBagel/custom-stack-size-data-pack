# Initial setup. Only run once when the datapack gets first added to a world
# Create scoreboard objectives, teams, etc here

root = ctx.meta.namespace

# Set currently installe datapack version
data modify storage minecraft:ab.custom_stack_size version set value "0.1.0"

objectives = [
]

for objective in objectives:
  if type(objective) is str:
    objective = [objective, "dummy"]
  
  if (type(objective) is list) and len(objective) == 1:
    objective.append("dummy")
  
  scoreboard objectives add f'{root}.{objective[0]}' objective[1]