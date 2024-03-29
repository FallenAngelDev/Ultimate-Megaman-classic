class_name Bullet
extends CharacterBody2D

@export var damage : int
@export var friend : bool
@export var speed : int
@export var death_timer : float = 3
@export var gravity : float

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_timer_timeout() -> void:
	queue_free()
