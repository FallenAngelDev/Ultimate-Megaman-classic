extends Enemy

@onready var sprite := $AnimatedSprite2D

var shild_block = true
var target : Megaman
var pick_axe := preload("res://scenes/enemys/bullets/pick_axe.tscn")

func _ready() -> void:
	super._ready()
	velocity.x = -100

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		gravity()
		move_and_slide()

func _on_hurt_box_body_entered(body: Bullet) -> void:
	if shild_block == true:
		reflet_bullet(body)
		return
	if body.friend:
		receive_damage(body.damage)
		sprite.material.set("shader_param/active",true)
		await get_tree().create_timer(0.1).timeout
		sprite.material.set("shader_param/active",false)
		body.queue_free()

func _on_player_detector_body_entered(body: Megaman) -> void:
	$ThrowTimer.start()
	target = body

func _on_player_detector_body_exited(body: Megaman) -> void:
	shild_block = true
	$ThrowTimer.stop()
	sprite.play("idle")
	target = null

func _on_throw_timer_timeout() -> void:
	shild_block = false
	sprite.play("throwing")
	var pick_axe_instance := pick_axe.instantiate() as Bullet
	get_parent().add_child(pick_axe_instance)
	pick_axe_instance.global_position = global_position
	var distance := Vector2(target.global_position - global_position)/16
	var gravity = pick_axe_instance.gravity
	pick_axe_instance.velocity = Vector2(pick_axe_instance.speed * distance.x/gravity, -pick_axe_instance.speed * 2)
	if distance.x > 0:
		sprite.flip_h = true
	else :
		sprite.flip_h = false
