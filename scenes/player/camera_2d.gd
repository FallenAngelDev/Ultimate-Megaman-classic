extends Camera2D

var current_screen := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var main_screen = (get_parent().global_position / get_viewport_rect().size).floor()
	if current_screen != main_screen:
		_update_screen(main_screen)

func _update_screen(new_screen):
	current_screen = new_screen
