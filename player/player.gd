extends CharacterBody2D

class_name Player

signal healthChanged

@export var speed: int = 35
@export var maxHealth = 3
@export var knockbackPower: int = 500
@export var inventory: Inventory

@onready var animations = $AnimationPlayer
@onready var effects = $Effects
@onready var HurtBox = $HurtBox
@onready var hurtTimer = $hurtTimer
@onready var sprite = $Sprite2D
@onready var currentHealth: int = maxHealth
@onready var weapon = $weapon
@onready var attack_sound = $AttackSound

var lastAnimDirection: String = "Down"
var isHurt: bool = false
var isAttacking: bool = false

func _ready():
	effects.play("RESET")

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection*speed

	if Input.is_action_just_pressed("attack"):
		attack()
		

func attack():
	if isAttacking:
		return
	
	isAttacking = true
	animations.play("attack" + lastAnimDirection)
	attack_sound.stop()
	attack_sound.play()
	weapon.enable()

	await animations.animation_finished

	weapon.disable()
	isAttacking = false
	
	# go back to idle AFTER attack
	animations.play("idle" + lastAnimDirection)


func updateAnimation():
	if isAttacking:
		return
	
	if velocity.length() == 0:
		animations.play("idle" + lastAnimDirection)
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
		
		lastAnimDirection = direction
		animations.play("walk" + direction)

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

func _physics_process(_delta):
	handleInput()
	
	if not isAttacking:
		updateAnimation()
	
	move_and_slide()
	handleCollision()
	
	if !isHurt:
		for area in HurtBox.get_overlapping_areas():
			if area.name == "HitBox":
				hurtByEnemy(area)

func hurtByEnemy(area):
	currentHealth -= 1
	if currentHealth < 0:
		currentHealth = maxHealth
	healthChanged.emit(currentHealth)
	isHurt = true

	knockback(area.get_parent().velocity)
	effects.play("hurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effects.play("RESET")
	isHurt = false

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.has_method("collect"):
		area.collect(inventory)

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

func _on_hurt_box_area_exited(_area: Area2D) -> void: pass
