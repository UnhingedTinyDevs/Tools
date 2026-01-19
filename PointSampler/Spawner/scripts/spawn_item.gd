extends Resource
class_name SpawnItem
## A Data class for a spawnable Item.
##
## Contains all the info needed about an item to spawn
## it with the [Spawner] class.

@export var sname: StringName = "" ## a name to refrence the item by
@export var scene: PackedScene = null ## The scene that should be spawned
@export var priority: int = 1  ## How much should the spawner favoriate this scene.
@export var max_count: int = 20 ## How many of this item can be spawned by EACH spawner at a time.
