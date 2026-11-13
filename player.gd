
extends CharacterBody2D

@export var speed = 180.0
@export var run_speed = 280.0
@export var jump_velocity = -350.0

var gravity = ProjectSettings.get_setting(
    "physics/2d/default_gravity"
)

var was_on_floor = true
var landing = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	# Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movimento
	var direction = Input.get_axis("ui_left", "ui_right")

	var running = Input.is_action_pressed("run")
	var current_speed = run_speed if running else speed

	velocity.x = direction * current_speed

	# Direção da personagem
	if direction != 0:
		sprite.flip_h = direction < 0

	# Pulo
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor() and not landing:
			velocity.y = jump_velocity

	move_and_slide()

	# Detecta o momento em que aterrissa
	if not was_on_floor and is_on_floor():
		landing = true
		sprite.play("land")

	was_on_floor = is_on_floor()

	# Não interrompe a animação de aterrissagem
	if landing:
		if not sprite.is_playing():
			landing = false
		return

	# Escolhe a animação
	var next_animation = "idle"

	if not is_on_floor():
		if velocity.y < 0:
			next_animation = "jump"
		else:
			next_animation = "fall"
	elif direction != 0:
		if running:
			next_animation = "run"
		else:
			next_animation = "walk"

	if sprite.animation != next_animation:
		sprite.play(next_animation)
