extends Node2D

var keepCombo = false # checking if the hit keeps the combo working, if it does then the animation plays
var combo = 0
var highest_combo = 0
enum TimingJudgement {MISS, WHAT, OK, GOOD, PERFECT}

var perfect := 0;
var good := 0;
var ok := 0;
var miss := 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (combo > highest_combo):
		highest_combo = combo
	pass
	
	
# basically the update_points function from Highscore but with the combo. Increases if it's great or perfect,
# resets combo to 0 if okay/miss/what.
func check_combo(type: TimingJudgement):
	match(type):
		TimingJudgement.MISS:
			combo = 0;
			miss += 1
			keepCombo = false;
		TimingJudgement.WHAT:
			combo = 0;
			miss += 1
			keepCombo = false;
		TimingJudgement.OK:
			combo = 0;
			ok += 1
			keepCombo = false;
		TimingJudgement.GOOD:
			combo += 1;
			good += 1;
			keepCombo = true;
		TimingJudgement.PERFECT:
			combo += 1;
			perfect += 1;
			keepCombo = true;
