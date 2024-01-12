extends TileMap

@export var spike_id : Vector2i
@export var spike_scene : PackedScene

func _ready() -> void:
	#_switch_tile(spike_id,spike_scene)
	pass

func _switch_tile(tile_id,node):
	var tiles = get_used_cells_by_id(0,-1,spike_id)
	for tile in tiles:
		var pos = map_to_local(tile)
		var node_instance = node.instantiate()
		add_child(node_instance)
		node_instance.position = pos
		set_cell(0,tile,-1,Vector2i(-1,-1))
