extends Parallax2D

@onready var sprite_2d = $Sprite2D

@export var texture: Texture2D

func _ready():
	SignalManager.on_plane_died.connect(_on_plane_died)
	sprite_2d.texture = texture
	var scale_f = get_viewport_rect().size.y / texture.get_height()
	sprite_2d.texture = texture
	sprite_2d.scale = Vector2(scale_f, scale_f)
	repeat_size.x = texture.get_width() * scale_f


func _process(delta):
	scroll_offset.x -= delta * GameManager.SCROLL_SPEED


func _on_plane_died():
	set_process(false)
