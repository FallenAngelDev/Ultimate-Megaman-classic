extends PathFollow2D

@onready var anim = $AnimationPlayer
var speed := 0.8

func _physics_process(_delta: float) -> void:
	if progress_ratio == 0:
		speed = abs(speed)
	elif progress_ratio == 1:
		speed = -speed
	progress += speed

func _on_area_2d_body_entered(_body: TileMap) -> void:
	anim.play("moving_platform")
	$PlatFormCollision/CollisionShape2D.set_deferred("disabled",true)

func _on_area_2d_body_exited(_body: TileMap) -> void:
	anim.play_backwards("moving_platform")
	$PlatFormCollision/CollisionShape2D.set_deferred("disabled",false)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$PlatformAudio.play()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$PlatformAudio.stop()
