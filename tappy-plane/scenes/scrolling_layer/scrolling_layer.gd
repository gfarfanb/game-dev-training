extends ParallaxLayer

const IMG_WIDTH: float =  1920.0
const IMG_HEIGHT: float =  1080.0

@onready var sprite_2d = $Sprite2D

@export var texture: Texture2D
@export var scroll_scale: float = 0.0


func _ready():
	motion_scale.x = scroll_scale
	var scale_factor = get_viewport_rect().size.y / IMG_HEIGHT
	sprite_2d.texture = texture
	sprite_2d.scale = Vector2(scale_factor, scale_factor)
	motion_mirroring.x = IMG_WIDTH * scale_factor
