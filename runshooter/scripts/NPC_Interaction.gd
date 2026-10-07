extends CharacterBody3D

@export var dialogues: Array[String] = [
	"Bonjour je suis Pierre",
	"Tu veux ma photo ?!",
	"Tiens"
]

@onready var interaction_icon: Label3D = $InteractionUI/InteractionIcon
@onready var interaction_arrow: Label3D = $InteractionUI/InteractionArrow
@onready var interaction_ui: Node3D = $InteractionUI
@export var icon_distance := 0.8
@export var icon_height := 2.2


func _ready():
	interaction_icon.visible = false
	interaction_arrow.visible = false

func set_interaction_visible(p_visible: bool):
	interaction_icon.visible = p_visible
	interaction_arrow.visible = p_visible


func interact():
	for dialogue in dialogues:
		print("Pierre : ", dialogue)

func _process(_delta):
	var camera := get_viewport().get_camera_3d()

	if camera == null:
		return

	interaction_ui.look_at(
		Vector3(camera.global_position.x, interaction_ui.global_position.y, camera.global_position.z),
		Vector3.UP
	)
