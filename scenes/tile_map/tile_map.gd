@tool
class_name MetroidVaniaMap
extends TileMap

@export var camera : Camera2D

func _enter_tree() -> void:
	if camera != null:
		tile_set.tile_size = get_viewport_rect().size
		print(get_viewport_rect().size)

	#tile_set.tile_size = Vector2(200,200)
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
