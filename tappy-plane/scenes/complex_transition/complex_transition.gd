extends CanvasLayer

func switch_scene():
	GameManager.load_next_scene()


func _on_animation_player_animation_finished(anim_name):
	queue_free()
