extends Area2D
class_name Gem

@export var speed: float = 100.0

signal on_gem_off_screen

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta
	
	if position.y > get_viewport_rect().size.y:
		on_gem_off_screen.emit()
		set_process(false)
		queue_free()
