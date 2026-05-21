extends CharacterBody3D

signal coin_collected

@export_subgroup("Components")
@export var view: Node3D

@export_subgroup("Properties")
@export var movement_speed = 250
@export var jump_strength = 7
@export var mouse_sensitivity = 0.005

var movement_velocity: Vector3
var gravity = 0

var previously_floored = false

var jump_single = true
var jump_double = true

var coins = 0

# Rotation verticale caméra
var camera_rotation_x = 0.0

@onready var pivot = $View/CameraPivot

@onready var particles_trail = $ParticlesTrail
@onready var sound_footsteps = $SoundFootsteps
@onready var model = $Character
@onready var animation = $Character/AnimationPlayer

# =========================
# READY
# =========================

func _ready():

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# =========================
# SOURIS
# =========================

func _input(event):

	if event is InputEventMouseMotion:

		# Rotation gauche/droite
		view.rotate_y(-event.relative.x * mouse_sensitivity)

		# Rotation haut/bas
		camera_rotation_x -= event.relative.y * mouse_sensitivity

		camera_rotation_x = clamp(
			camera_rotation_x,
			deg_to_rad(-70),
			deg_to_rad(20)
		)

		pivot.rotation.x = camera_rotation_x

# =========================
# PHYSICS
# =========================

func _physics_process(delta):

	# La caméra suit le joueur
	view.global_position = global_position

	handle_controls(delta)
	handle_gravity(delta)
	handle_effects(delta)

	var applied_velocity: Vector3

	applied_velocity = velocity.lerp(
		movement_velocity,
		delta * 10
	)

	applied_velocity.y = -gravity

	velocity = applied_velocity

	move_and_slide()

	# Respawn si chute
	if position.y < -10:
		get_tree().reload_current_scene()

	# Animation scale
	model.scale = model.scale.lerp(
		Vector3(1, 1, 1),
		delta * 10
	)

	# Effet atterrissage
	if is_on_floor() and gravity > 2 and !previously_floored:

		model.scale = Vector3(1.25, 0.75, 1.25)

		Audio.play("res://sounds/land.ogg")

	previously_floored = is_on_floor()

# =========================
# EFFECTS
# =========================

func handle_effects(delta):

	particles_trail.emitting = false
	sound_footsteps.stream_paused = true

	if is_on_floor():

		var horizontal_velocity = Vector2(
			velocity.x,
			velocity.z
		)

		var speed_factor = horizontal_velocity.length() / movement_speed / delta

		if speed_factor > 0.05:

			if animation.current_animation != "walk":
				animation.play("walk", 0.1)

			if speed_factor > 0.3:
				sound_footsteps.stream_paused = false
				sound_footsteps.pitch_scale = speed_factor

			if speed_factor > 0.75:
				particles_trail.emitting = true

		elif animation.current_animation != "idle":

			animation.play("idle", 0.1)

	elif animation.current_animation != "jump":

		animation.play("jump", 0.1)

# =========================
# CONTROLS
# =========================

func handle_controls(delta):

	var input := Vector3.ZERO

	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")

	# Direction caméra
	var camera_basis = view.global_transform.basis

	var forward = -camera_basis.z
	var right = camera_basis.x

	# Ignore la hauteur
	forward.y = 0
	right.y = 0

	forward = forward.normalized()
	right = right.normalized()

	# Direction finale
	var direction = (right * input.x) - (forward * input.z)

	if direction.length() > 1:
		direction = direction.normalized()

	movement_velocity = direction * movement_speed * delta

	# Orientation personnage
	if direction.length() > 0:

		model.rotation.y = lerp_angle(
			model.rotation.y,
			atan2(direction.x, direction.z),
			delta * 10
		)

	if direction.length() > 1:
		direction = direction.normalized()

	movement_velocity = direction * movement_speed * delta

	# Jump
	if Input.is_action_just_pressed("jump"):

		if jump_single or jump_double:
			jump()

# =========================
# GRAVITY
# =========================

func handle_gravity(delta):

	gravity += 25 * delta

	if gravity > 0 and is_on_floor():

		jump_single = true
		gravity = 0

# =========================
# JUMP
# =========================

func jump():

	Audio.play("res://sounds/jump.ogg")

	gravity = -jump_strength

	model.scale = Vector3(0.5, 1.5, 0.5)

	if jump_single:

		jump_single = false
		jump_double = true

	else:

		jump_double = false

# =========================
# COINS
# =========================

func collect_coin():

	coins += 1

	coin_collected.emit(coins)
