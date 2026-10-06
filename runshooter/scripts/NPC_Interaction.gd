extends CharacterBody3D


@export var dialogues: Array[String] = [
	"Bonjour je m'appelle Pierre",
]


func interact():
	print("Pierre :")

	for dialogue in dialogues:
		print(dialogue)
