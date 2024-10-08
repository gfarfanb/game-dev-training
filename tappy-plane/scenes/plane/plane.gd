extends CharacterBody2D

class_name  Tappy

const GRAVITY: float = 1000.0
const POWER: float = -350.0

@onready var propeller_animation = $PropellerAnimation
@onready var player_animation = $PlayerAnimation
@onready var sound = $Sound


func _ready():
	pass


func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
	fly()
	move_and_slide()
	
	if is_on_floor():
		die()


func fly():
	if Input.is_action_pressed("fly"):
		velocity.y = POWER
		player_animation.play("power")


func die():
	propeller_animation.stop()
	sound.stop()
	set_physics_process(false)
	SignalManager.on_plane_died.emit()
