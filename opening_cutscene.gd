extends Node2D

@onready var text_label = $DialogueUI/Panel/Label
@onready var name_label = $DialogueUI/Panel/NameLabel
@onready var music = $AudioStreamPlayer

var dialogue = [
	"Help me...",
	"Please... I need your help...",
	"How long have I been waiting?",
	"Find me in the forest...",
    "Please... don't leave me..."
]

var index = 0

func _ready():
	name_label.text = "CaveGirl"
	show_text()
	music.play()

func show_text():
	text_label.text = dialogue[index]

func _input(event):
	if event.is_action_pressed("ui_accept"):
		index += 1
		
		if index < dialogue.size():
			show_text()
		else:
			end_cutscene()

func end_cutscene():
	get_tree().change_scene_to_file("res://scenes/world.tscn")
