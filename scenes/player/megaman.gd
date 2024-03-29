class_name Megaman
extends CharacterBody2D

@onready var anim := $AnimationPlayer
@onready var hp_bar := $CanvasLayer/HpBar
@onready var weapon := $Buster
@onready var defeat_explosion := preload("res://scenes/player/death_explosion_particle.tscn")

const SPEED = 100.0
const JUMP_FORCE = 300

var current_state
var animations : Array
var normal_animations := ["idle","run","jump"]
var shoot_animations := ["shoot","run_shoot","jump_shoot"]
var max_jump_height := 4 * 16
var min_jump_height := 0.5 * 16
var hp : int = 100
var max_jump_velocity : float
var min_jump_velocity : float
var jump_duration := 0.4
var gravity

enum {IDLE,RUN,JUMP,FROZEN}

func _ready() -> void:
	current_state = IDLE
	animations = normal_animations
	gravity = 2 *  max_jump_height / pow(jump_duration, 2)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)

func _physics_process(delta: float) -> void:
	match current_state:
		IDLE:
			_idle_state()
			_gravity(delta)
			move_and_slide()
		RUN:
			_run_state()
			move_and_slide()
		JUMP:
			_jump_state()
			_gravity(delta)
			_movement()
			move_and_slide()
		FROZEN:
			move_and_slide()
	
	#if Input.is_action_just_pressed("ui_shoot"):
		#animations = shoot_animations
		#$ShootTimer.start()

func _idle_state():
	anim.play(animations[0])
	if _movement():
		current_state = RUN
	if _can_jump():
		_jump(max_jump_velocity)
	if !is_on_floor():
		current_state = JUMP

func _run_state():
	anim.play(animations[1])
	if !_movement():
		current_state = IDLE
	if _can_jump():
		_jump(max_jump_velocity)
	if !is_on_floor():
		current_state = JUMP

func _jump_state():
	anim.play(animations[2])
	if is_on_floor() and velocity.y >= 0:
		current_state = IDLE
		$LandSound.play()
	if Input.is_action_just_released("ui_accept") and velocity.y <= 0:
		velocity.y = min_jump_velocity
	pass

func _movement():
	var direction = Input.get_axis("ui_left","ui_right")
	if direction != 0:
		velocity.x = SPEED * direction
		transform.x.x = direction
		return true
	velocity.x = 0
	return false

func _gravity(_delta):
	velocity.y += gravity * _delta

func _jump(jump_force):
	velocity.y = jump_force

func _can_jump():
	if Input.is_action_just_pressed("ui_accept"):
		current_state = JUMP
		return true
	return false

#func _on_shoot_timer_timeout() -> void:
	#animations = normal_animations
	#$ShootTimer.stop()

func _damage(damage : int ,repulsion : bool):
	if current_state == FROZEN:
		return
	current_state = FROZEN
	$DamageSound.play()
	velocity = Vector2.ZERO
	if repulsion:
		velocity.x = -25 * transform.x.x
	hp -= damage
	hp_bar.value -= damage
	if hp_bar.value == 0:
		_death()
	anim.play("damage")
	await get_tree().create_timer(0.5).timeout
	current_state = IDLE

func _update_screen_limt(pos1,pos2):
	var camera := $Camera2D as Camera2D
	var current_speed := camera.position_smoothing_speed
	velocity = 20 * velocity.normalized()
	camera.position_smoothing_speed = 2.0
	camera.limit_top = get_viewport_rect().size.y * pos1.y
	camera.limit_left = get_viewport_rect().size.x * pos1.x
	camera.limit_right = get_viewport_rect().size.x * (pos2.x + 1)
	camera.limit_bottom = get_viewport_rect().size.y * (pos2.y + 1)
	await get_tree().create_timer(2).timeout
	camera.position_smoothing_speed = current_speed

func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body as Enemy:
		var enemy = body as Enemy
		_damage(enemy.damage, true)
	if body as Bullet:
		var bullet = body as Bullet
		if bullet.friend == false:
			_damage(body.damage, false)
	if body as Item:
		var item = body as Item
		_charge_bar(item.amount)
		item.queue_free()
	if body.is_in_group("Spikes"):
		print("atingiu")
	if body as TileMap:
		_death()

func _death():
	velocity = Vector2.ZERO
	$Sprite2D.visible = false
	$HurtBox/CollisionShape2D.set_deferred("disabled",true)
	var explosion = defeat_explosion.instantiate() as CPUParticles2D
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	explosion.emitting = true
	await get_tree().create_timer(3).timeout
	get_tree().reload_current_scene()

func _charge_bar(amount):
	if hp_bar.value == hp_bar.max_value:
		return
	current_state = FROZEN
	anim.stop()
	velocity = Vector2.ZERO
	$ChargeBar.play()
	for i in amount:
		await get_tree().create_timer(0.1).timeout
		hp_bar.value += 1
	current_state = IDLE
	$ChargeBar.stop()
