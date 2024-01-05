class_name Stage
extends Node2D

var enemys : Array[Enemy]
var megaman : Megaman
var current_screen := Vector2.ZERO

#func _ready() -> void:
	#for child in get_children():
		#if child as Enemy:
			#enemys.append(child)
		#elif child as Megaman:
			#megaman = child
#
#func _physics_process(delta: float) -> void:
	#var main_screen = (megaman.global_position / get_viewport_rect().size).floor()
	#if current_screen != main_screen:
		#_update_screen(main_screen)
#
#func _update_screen(next_screen : Vector2):
	#current_screen = next_screen
	#for enemy in enemys:
		#if enemy == null:
			#continue
		#if enemy.main_screen == current_screen:
			#enemy.active = true
		#else:
			#enemy.active = false
		#enemy._update_main_screen()
