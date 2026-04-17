extends BaseScene

@onready var heartsContainer = $CanvasLayer/HeartsContainer
@onready var music = $AdventureMusic
@onready var camera = $follow_cam

func _ready():
	super()
	camera.follow_node = player 

	if player:
		heartsContainer.setMaxHearts(player.maxHealth)
		heartsContainer.updateHearts(player.currentHealth)
		player.healthChanged.connect(heartsContainer.updateHearts)

	music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_inventory_gui_closed() -> void:
	get_tree().paused = false


func _on_inventory_gui_opened() -> void:
	get_tree().paused = true
