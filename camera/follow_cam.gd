extends Camera2D

@onready var screen_size: Vector2 = get_viewport_rect().size
@onready var player_node = get_tree().get_first_node_in_group("player")
@export var tilemap: TileMap
@export var follow_node: Node2D

func _ready() -> void:
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.cell_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize

	limit_right = worldSizeInPixels.x
	limit_bottom = worldSizeInPixels.y

func _process(_delta):
	global_position = follow_node.global_position
