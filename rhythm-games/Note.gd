extends Sprite2D

const SCREEN_BOTTOM := 600
var speed: float = 100.0
var expected_time: float = 0.0 # used to track when they appear in the queue
const TIME_TOLERANCE := {
	"PERFECT": 0.05,
	"GOOD": 0.08,
	"OK": 0.12
}

func _process(delta: float) -> void:
	global_position.y += speed * delta
	
	if global_position.y >= SCREEN_BOTTOM:
		queue_free()
			
func test_hit(time: float) -> bool:
	return abs(expected_time - time) <= TIME_TOLERANCE.OK

func test_miss(time: float) -> bool:
	return time > expected_time + TIME_TOLERANCE.OK

func hit(time: float) -> void:
	var time_difference: float = abs(expected_time - time)
	
	if time_difference < TIME_TOLERANCE.PERFECT:
		Highscore.update_points(Highscore.TimingJudgement.PERFECT)
		Combo.check_combo(Combo.TimingJudgement.PERFECT)
	elif time_difference < TIME_TOLERANCE.GOOD:
		Highscore.update_points(Highscore.TimingJudgement.GOOD)
		Combo.check_combo(Combo.TimingJudgement.GOOD)
	else:
		Highscore.update_points(Highscore.TimingJudgement.OK)
		Combo.check_combo(Combo.TimingJudgement.OK)
	queue_free()

func miss() -> void:
	Highscore.update_points(Highscore.TimingJudgement.MISS)
	Combo.check_combo(Combo.TimingJudgement.MISS)
