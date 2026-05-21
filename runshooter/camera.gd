extends Camera3D

@export var sensitivity := 0.2

@onready var pivot = get_parent()

var rotation_y := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):

	# Reset caméra (R)
	if Input.is_action_just_pressed("reset_camera"):
		reset_camera()

func _input(event):

	# Clique → capturer souris
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# ESC → libérer souris
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Mouvement souris
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:

		rotation_y -= event.relative.x * sensitivity
		pivot.rotation_degrees.y = rotation_y

func reset_camera():
	rotation_y = 0
	pivot.rotation_degrees.y = 0
