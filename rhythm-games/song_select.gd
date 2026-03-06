extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_song_1_pressed() -> void:
	pass
	get_tree().change_scene_to_file("res://main.tscn")
	Globals.song_choice = 1


func _on_song_2_pressed() -> void:
	pass
	get_tree().change_scene_to_file("res://main.tscn")
	Globals.song_choice = 2
