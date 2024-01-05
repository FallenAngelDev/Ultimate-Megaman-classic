extends Bullet

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	velocity.y += gravity
