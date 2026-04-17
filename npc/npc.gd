extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5
@export var endPoint: Marker2D
@export var dialogue_text: String = "You save me!"

@onready var animations = $AnimationPlayer
@onready var interaction_area = $InteractionArea
@onready var dialogue_panel = $DialogueUI/Panel
@onready var dialogue_label = $DialogueUI/Panel/Label

var startPosition
var endPosition
var player_in_range = false
var is_talking = false

func _ready():
	startPosition = position
	endPosition = endPoint.global_position
	
	dialogue_panel.visible = false
	
	interaction_area.body_entered.connect(_on_interaction_area_body_entered)
	interaction_area.body_exited.connect(_on_interaction_area_body_exited)

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	if is_talking:
		velocity = Vector2.ZERO
		return
	
	var moveDirection = (endPosition - position)
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized() * speed

func updateAnimation():
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()
	else:
		var direction = "down"
		if velocity.x < 0:
			direction = "left"
		elif velocity.x > 0:
			direction = "right"
		elif velocity.y < 0:
			direction = "up"
	
		animations.play("walk_" + direction)

func _physics_process(_delta):
	updateVelocity()
	move_and_slide()
	updateAnimation()

func _unhandled_input(event):
	if player_in_range and event.is_action_pressed("interact"):
		if is_talking:
			end_dialogue()
		else:
			start_dialogue()

func start_dialogue():
	is_talking = true
	velocity = Vector2.ZERO
	dialogue_label.text = dialogue_text
	dialogue_panel.visible = true

func end_dialogue():
	is_talking = false
	dialogue_panel.visible = false

func _on_interaction_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_interaction_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		if is_talking:
			end_dialogue()
