class_name Enemy
extends CharacterBody2D

@export var hp : int
@export var damage : int
@onready var audio := preload("res://assets/audios/effetcs/enemyDamage.wav")
@onready var explosion := preload("res://scenes/enemys/explosion.tscn")
@onready var dink_audio := preload("res://assets/audios/effetcs/dink.wav")

var closed := true
var dink_stream := AudioStreamPlayer.new()
var main_screen := Vector2.ZERO
var current_megaman_screen := Vector2.ZERO
var audio_stream = AudioStreamPlayer.new()
var screen_notifier = VisibleOnScreenEnabler2D.new()

func _ready() -> void:
	dink_stream.stream = dink_audio
	audio_stream.stream = audio
	add_child(dink_stream)
	add_child(audio_stream)
	add_child(screen_notifier)
	screen_notifier.enable_node_path = self.get_path()

func receive_damage(_damage):
	audio_stream.play()
	hp -= _damage
	if hp <= 0:
		var instance = explosion.instantiate() as AnimatedSprite2D
		get_parent().add_child(instance)
		instance.global_position = global_position
		queue_free()

func reflet_bullet(bullet : Bullet):
	bullet.velocity = Vector2((-1 * bullet.velocity.x)/2 , -abs(bullet.velocity.x/2))
	dink_stream.play() 

func gravity():
	velocity.y += 5
