class_name Item
extends CharacterBody2D

@export var amount : int

func _physics_process(_delta: float) -> void:
	if !is_on_floor():
		velocity.y += 5
		move_and_slide()
