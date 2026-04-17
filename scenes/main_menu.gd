extends Control

@onready var music = $AudioStreamPlayer
@onready var anim = $AnimationPlayer

func _ready() -> void:
	anim.play("Appear_Title")
	music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://opening_cutscene.tscn")


func _on_option_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
