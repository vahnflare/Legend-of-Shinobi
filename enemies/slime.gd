extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5
@export var endPoint: Marker2D
@export var knockback_power: float = 200
@export var health: int = 3

@onready var animations = $AnimationPlayer

var startPosition
var endPosition
var isDead: bool = false
var knockback_velocity: Vector2 = Vector2.ZERO
var isKnockback: bool = false

func _ready():
	startPosition = position
	endPosition = endPoint.global_position

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	var moveDirection = (endPosition - position)
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized()*speed

func updateAnimation():
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y <0: direction = "Up"
	
		animations.play("walk" + direction)

func _physics_process(delta):
	if isDead:
		return

	if isKnockback:
		velocity = knockback_velocity
		move_and_slide()

		# slow down knockback over time
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 500 * delta)

		if knockback_velocity.length() < 10:
			isKnockback = false
		return

	updateVelocity()
	move_and_slide()
	updateAnimation()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if isDead:
		return
	
	if not area.is_in_group("player_attack"):
		return
	
	var player = area.get_parent()
	var direction = (global_position - player.global_position).normalized()
	
	knockback_velocity = direction * knockback_power
	isKnockback = true
	health -= 1
	
	if health <= 0:
		die()

func die():
	isDead = true
	$HitBox.set_deferred("monitoring", false)
	animations.play("death")
	await animations.animation_finished
	queue_free()
