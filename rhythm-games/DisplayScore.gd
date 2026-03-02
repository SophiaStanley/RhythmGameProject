extends Node2D

# this should be called "DisplayCombo" but I kept getting combo and score mixed up in my head...

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	$ComboLabel.text = str(Combo.combo, " Combo")
	Combo.keepCombo = false
	
	if (Combo.keepCombo == true):
		$AnimationPlayer.play("hit")
