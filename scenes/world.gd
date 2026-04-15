extends BaseScene

@onready var heartsContainer = $CanvasLayer/HeartsContainer
@onready var music = $AdventureMusic

func _ready():
	super()
	await get_tree().process_frame  

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
