class_name Bullet
extends CharacterBody2D

@export var damage : int
@export var friend : bool
@export var speed : int
@export var death_timer : float = 3

func _ready() -> void:
	await get_tree().create_timer(death_timer).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	move_and_slide()
