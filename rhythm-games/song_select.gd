extends Node2D

func _on_song_1_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	Globals.song_choice = 1


func _on_song_2_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	Globals.song_choice = 2
