extends Camera2D

@onready var screen_size: Vector2 = get_viewport_rect().size
@onready var player_node = get_tree().get_first_node_in_group("player")
@export var tilemap: TileMap

func _ready() -> void:
	set_screen_position()
	await get_tree().process_frame
	position_smoothing_enabled = true
	position_smoothing_speed = 7.0

	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.cell_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize

	limit_right = worldSizeInPixels.x
	limit_bottom = worldSizeInPixels.y

var current_room := Vector2(-1, -1)

func _process(_delta):
	if player_node == null:
		return

	var player_pos = player_node.global_position
	var new_room = Vector2(
		floor(player_pos.x / screen_size.x),
		floor(player_pos.y / screen_size.y)
	)

	if new_room != current_room:
		current_room = new_room
		set_screen_position()

func set_screen_position():
	if player_node == null:
		return

	var player_pos = player_node.global_position
	var x = floor(player_pos.x / screen_size.x) * screen_size.x + screen_size.x / 2
	var y = floor(player_pos.y / screen_size.y) * screen_size.y + screen_size.y / 2
	global_position = Vector2(x, y)
