extends BaseScene

func _ready():
	if scene_manager.player:
		add_child(scene_manager.player)
