extends Control

func _process(delta: float) -> void:
	$StellarStageLogo/LogoAnimation.play("logo")
	pass
	
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	pass
