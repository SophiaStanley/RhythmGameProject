extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Perfects.text = ("perfect: " + str(Combo.perfect))
	$Goods.text = ("great: " + str(Combo.good))
	$OKs.text = ("OK: " + str(Combo.ok))
	$Miss.text = ("Miss: " + str(Combo.miss))
	pass


func _on_title_button_pressed() -> void:
	get_tree().change_scene_to_file("res://title_screen.tscn")
	reset()
	pass # Replace with function body.


func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	reset()
	pass # Replace with function body.

func reset() -> void:
	Combo.combo = 0
	Combo.perfect = 0
	Combo.good = 0
	Combo.ok = 0
	Combo.miss = 0
	Highscore.displayed_points = 0
	Highscore.points = 0
