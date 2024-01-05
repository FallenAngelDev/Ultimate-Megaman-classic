extends  CharacterBody2D

var closed := true
var dink_stream := AudioStreamPlayer.new()
var dink_audio := preload("res://assets/audios/effetcs/dink.wav")

func _ready() -> void:
	add_child(dink_stream)
	dink_stream.stream = dink_audio

func reflet_bullet(bullet : Bullet):
	bullet.velocity = Vector2((-1 * bullet.velocity.x)/2 , -abs(bullet.velocity.x/2))
	dink_stream.play() 
