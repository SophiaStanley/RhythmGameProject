extends Control

func _process(_delta: float) -> void:
	#playing logo animation (the stars changing position)
	$StellarStageLogo/LogoAnimation.play("logo")
	pass
	
# game starts when button is pressed
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://song_select.tscn")
	pass
