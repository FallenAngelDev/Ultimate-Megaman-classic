extends Area2D

var sprites_open : Array[Node]
var sprites_close : Array[Node]
var entered := false
var room_pos

func _ready() -> void:
	room_pos = ($Marker2D.global_position / get_viewport_rect().size).floor()
	var sprites_parent_open = $SpritesOpen
	var sprites_parent_close = $SpritesClose
	sprites_open = sprites_parent_open.get_children()
	sprites_close = sprites_parent_close.get_children()
	sprites_open.reverse()

func _on_body_entered(body: Megaman) -> void:
	if entered:
		return
	body.velocity = Vector2.ZERO
	body.current_state = body.FROZEN
	$AudioStreamPlayer.play()
	for sprite in sprites_open:
		var current_sprite = sprite as AnimatedSprite2D
		current_sprite.play("open")
		await current_sprite.animation_finished
	body._update_screen_limt(room_pos,room_pos)
	body.velocity.x = 50
	$AudioStreamPlayer.stop()

func _on_body_exited(body: Megaman) -> void:
	if entered:
		return
	$DoorBarrier/CollisionShape2D.set_deferred("disabled", false)
	body.velocity = Vector2.ZERO
	$AudioStreamPlayer.play()
	for sprite in sprites_close:
		var current_sprite = sprite as AnimatedSprite2D
		current_sprite.play_backwards("open")
		await current_sprite.animation_finished
	$AudioStreamPlayer.stop()
	body.current_state = body.IDLE
	entered = true
