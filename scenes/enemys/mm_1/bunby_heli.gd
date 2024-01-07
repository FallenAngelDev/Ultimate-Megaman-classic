extends Enemy

const SPEED := 50.0

func _ready() -> void:
	super._ready()
	velocity.x = -SPEED

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_area_2d_body_entered(body: Bullet) -> void:
	if body.friend == true:
		receive_damage(body.damage)


func _on_mm_detector_body_entered(body: Megaman) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",body.position,1)
