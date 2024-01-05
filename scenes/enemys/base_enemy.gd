class_name Enemy
extends CharacterBody2D

@export var hp : int
@export var damage : int
@onready var audio := preload("res://assets/audios/effetcs/enemyDamage.wav")
@onready var explosion := preload("res://scenes/enemys/explosion.tscn")

var main_screen := Vector2.ZERO
var current_megaman_screen := Vector2.ZERO
var audio_stream = AudioStreamPlayer.new()
var screen_notifier = VisibleOnScreenEnabler2D.new()
#var active = false :
	#set(value):
		##visible = value
		#set_process(value)
		#set_physics_process(value)
		#active = value


func _ready() -> void:
	#_update_main_screen()
	#active = false
	audio_stream.stream = audio
	add_child(audio_stream)
	add_child(screen_notifier)
	screen_notifier.enable_node_path = self.get_path()
	#screen_notifier.connect("screen_entered",_visible)
	#screen_notifier.connect("screen_exited",_no_visible)

func _physics_process(delta: float) -> void:
	if screen_notifier.is_on_screen():
		print("AAAAA")

func receive_damage(_damage):
	audio_stream.play()
	hp -= _damage
	if hp <= 0:
		var instance = explosion.instantiate() as AnimatedSprite2D
		get_parent().add_child(instance)
		instance.global_position = global_position
		queue_free()

#func _update_main_screen():
	#main_screen = (global_position / get_viewport_rect().size).floor()

#func _visible():
	#active = true
	#print("visivel")
#
#func _no_visible():
	#active = false
