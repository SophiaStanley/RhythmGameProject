extends Node2D

var keepCombo = false # checking if the hit keeps the combo working
var combo = 0
enum TimingJudgement {MISS, WHAT, OK, GOOD, PERFECT}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
# basically the update_points function from Highscore but with the combo. Increases if it's great or perfect,
# resets combo to 0 if okay/miss/what.
func check_combo(type: TimingJudgement):
	match(type):
		TimingJudgement.MISS:
			combo = 0;
			keepCombo = false;
		TimingJudgement.WHAT:
			combo = 0;
			keepCombo = false;
		TimingJudgement.OK:
			combo = 0;
			keepCombo = false;
		TimingJudgement.GOOD:
			combo += 1;
			keepCombo = true;
		TimingJudgement.PERFECT:
			combo += 1;
			keepCombo = true;
