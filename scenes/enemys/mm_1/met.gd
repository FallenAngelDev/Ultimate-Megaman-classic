extends Enemy

@onready var sprite := $Sprite2D
@onready var bullet := preload("res://scenes/weapons/bullets/simple_bullet.tscn")

const DELAY := 1.5

var closed := true
var directions := [Vector2(2,0),Vector2(1,1),Vector2(1,-1)]
var target : CharacterBody2D

func _on_area_2d_body_entered(body: Bullet) -> void:
	if closed:
		body.velocity = Vector2((-1 * body.velocity.x)/2 , -abs(body.velocity.x/2)) 
		$DinkAudio.play()
		$Timer.start()
		return
	if body.friend == true:
		$AnimationPlayer.play("hit")
		receive_damage(body.damage)

func _physics_process(delta: float) -> void:
	if target == null:
		return
	if target.position.x <= position.x:
		transform.x.x = 1
	elif target.position.x >= position.x:
		transform.x.x = -1

func _on_area_2d_2_body_entered(body: Megaman) -> void:
	target = body
	$Timer.start()
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	sprite.frame = 1
	closed = false
	$ShootAudio.play()
	for direction in directions:
		var bullet_instance := bullet.instantiate() as Bullet
		get_parent().add_child(bullet_instance)
		bullet_instance.global_position = global_position
		bullet_instance.velocity = direction *  bullet_instance.speed  * -transform.x.x
	await get_tree().create_timer(DELAY).timeout
	closed = true
	sprite.frame = 0
	pass # Replace with function body.


func _on_area_2d_2_body_exited(body: Megaman) -> void:
	target = null
	$Timer.stop()
	pass # Replace with function body.
