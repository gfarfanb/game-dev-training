extends Area2D

@export var speed: float = 60.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += Input.get_axis("left", "right") * speed * delta


func _on_gem_area_entered(area):
	print(area)
