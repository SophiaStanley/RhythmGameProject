extends CanvasLayer


func update_score(score):
	$ScoreLabel.text = str(score)

func update_combo(combo):
	$ComboLabel.text = str(combo) + "\n Combo"
	if Combo.keepCombo == true:
		$ComboLabel/ComboAnimation.play("hit")
		Combo.keepCombo = false

func update_stamina(stamina):
	$StaminaLabel.text = str(stamina)
