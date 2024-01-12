class_name Entrace
extends Area2D

@onready var pos1maker := $Pos1
@onready var pos2maker := $Pos2
@onready var shape := $CollisionShape2D

var pos1 : Vector2
var pos2 : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pos1 = (pos1maker.global_position / get_viewport_rect().size).floor()
	pos2 = (pos2maker.global_position / get_viewport_rect().size).floor()
	shape.shape.size.y = get_viewport_rect().size.y

func _on_body_entered(body: Megaman) -> void:
	body._update_screen_limt(pos1,pos2)
	body.current_state = body.FROZEN

func _on_body_exited(body: Megaman) -> void:
	body.current_state = body.IDLE
