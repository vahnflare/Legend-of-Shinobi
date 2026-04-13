extends Area2D

@onready var shape = $CollisionShape2D

func _ready():
	add_to_group("player_attack")

func enable():
	shape.disabled = false

func disable():
	shape.disabled = true
