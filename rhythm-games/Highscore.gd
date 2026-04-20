extends Node

var points = 0;
var displayed_points = 0;
enum TimingJudgement {MISS, WHAT, OK, GOOD, PERFECT}
var feedback = "";

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_displayed_points()
	
func update_points(type: TimingJudgement):
	match(type):
		TimingJudgement.MISS:
			points -= 100;
			feedback = "Miss"
		TimingJudgement.WHAT:
			points -= 100;
			feedback = "Miss"
		TimingJudgement.OK:
			points += 200
			feedback = "Ok"
		TimingJudgement.GOOD:
			points += 500;
			feedback = "Good"
		TimingJudgement.PERFECT:
			points += 1000;
			feedback = "Perfect"

func update_displayed_points() -> void:
	var difference = abs(points - displayed_points)
 # Determine the step size dynamically
	var step = max(1, difference * 0.2)

	if displayed_points < points:
		displayed_points =  min(displayed_points + step, points);
	elif displayed_points > points:
		displayed_points = max(displayed_points - step,points)
  
	displayed_points = int(displayed_points)
