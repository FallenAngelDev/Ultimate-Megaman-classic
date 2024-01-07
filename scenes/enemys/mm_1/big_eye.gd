extends Enemy

@onready var sprite := $Sprite2D

var target : Megaman
var is_jumping := false

const JUMP_FORCE := 100.0

func _physics_process(_delta: float) -> void:
	if is_on_floor():
		sprite.frame = 0
		if is_jumping:
			is_jumping = false
			velocity = Vector2.ZERO
	else:
		sprite.frame = 1
	gravity()
	move_and_slide()

func _on_player_detector_body_entered(body: Megaman) -> void:
	target = body
	$JumpTimer.start()

func _on_jump_timer_timeout() -> void:
	var direction = roundi(position.direction_to(target.position).x)
	if direction == 1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	if is_on_floor():
		velocity = Vector2(JUMP_FORCE * direction, -JUMP_FORCE * 2)
	await get_tree().create_timer(0.5).timeout
	is_jumping = true

func _on_hurt_box_body_entered(body:Bullet) -> void:
	if body.friend == true:
		receive_damage(body.damage)
		sprite.material.set_shader_parameter("active",true)
		await get_tree().create_timer(0.1).timeout
		sprite.material.set_shader_parameter("active",false)
