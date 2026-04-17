class_name SceneTrigger extends Area2D

@export var connected_scene: String
@export var spawn_name: String 

func _on_body_entered(body):
	if body.name == "Player":
		call_deferred("_change_scene_safe")

func _change_scene_safe():
	scene_manager.spawn_name = spawn_name  
	scene_manager.change_scene(get_tree().current_scene, connected_scene)
