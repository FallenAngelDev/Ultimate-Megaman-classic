extends Node2D

@onready var buster_bullet : PackedScene = preload("res://scenes/Weapons/bullets/buster_bullet.tscn")
@onready var shoot_timer := $ShootTimer
@onready var buster_sound := $AudioStreamPlayer

var megaman : Megaman
var can_shooot := true
const  shoot_delay = 0.3
const bullet_speed = 200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	megaman = get_parent()

func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("ui_shoot"):
		if megaman.current_state == megaman.FROZEN:
			return
		if !can_shooot:
			return
		can_shooot = false
		megaman.animations = megaman.shoot_animations
		shoot_timer.start()
		_shoot()
		await get_tree().create_timer(shoot_delay).timeout
		can_shooot = true


func _shoot():
	buster_sound.play()
	var bullet_instance = buster_bullet.instantiate() as CharacterBody2D
	get_parent().get_parent().add_child(bullet_instance)
	self.scale = get_parent().scale
	bullet_instance.global_position = $Marker2D.global_position
	bullet_instance.velocity.x = bullet_speed * get_parent().transform.x.x

func _on_shoot_timer_timeout() -> void:
	shoot_timer.stop()
	megaman.animations = megaman.normal_animations
