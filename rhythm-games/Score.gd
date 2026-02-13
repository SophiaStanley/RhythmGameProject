extends Node2D


# Score Node
func _process(delta: float) -> void:
	pass
	$Label.text = str(Highscore.displayed_points)
