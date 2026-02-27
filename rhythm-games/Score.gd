extends Node2D


# Score Node
func _process(delta: float) -> void:
	pass
	$ScoreLabel.text = str(Highscore.displayed_points)
