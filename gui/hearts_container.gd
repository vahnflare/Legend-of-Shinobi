extends HBoxContainer

@onready var HeartGuiClass = preload("res://gui/heartGui.tscn")

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func setMaxHearts(max_hearts: int):
	for i in range(max_hearts):
		var heart = HeartGuiClass.instantiate()
		add_child(heart)

func updateHearts(currentHealth: int):
	var hearts = get_children()

	for i in range(currentHealth):
		hearts[i].update(true)

	for i in range(currentHealth, hearts.size()):
		hearts[i].update(false)
