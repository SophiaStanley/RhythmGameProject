# tutorial used for code:
# https://medium.com/@sergejmoor01/building-a-rhythm-game-in-godot-part-1-synchronizing-gameplay-with-music-258b0bcab458
extends Node2D

# the time that has passed since the game scene started. used for tracking time for syncing music
var delta_sum := 0.0
const TIMING_OFFSET := (1.0/FALLING_SPEED_SCALE)

const BUTTON_SPAWN_OFFSET := Vector2(32, 32)
const NOTE_Y_OFFSET := 400
const FALLING_SPEED_SCALE := 0.5
# Each note in the MIDI file represents a note in the game. This dictionary is used to link them together
# So it should play properly.
const NOTE_SCENE: PackedScene = preload("res://note.tscn")

@onready var notes: Dictionary = {
	36: {
		"key": "ui_up",
		"button": get_node("Buttons/UpButton"),
		"texture": preload("res://assets/sprites/Note2.png"),
		"queue": []
	},
	38: {
		"key": "ui_down",
		"button": get_node("Buttons/DownButton"),
		"texture": preload("res://assets/sprites/Note3.png"),
		"queue": []
	},
	40: {
		"key": "ui_left",
		"button": get_node("Buttons/LeftButton"),
		"texture": preload("res://assets/sprites/Note1.png"),
		"queue": []
	},
	42: {
		"key": "ui_right",
		"button": get_node("Buttons/RightButton"),
		"texture": preload("res://assets/sprites/Note4.png"),
		"queue": []
	}
}


# Game Node 
func _on_midi_player_midi_event(channel: Variant, event: Variant) -> void:
	if event.type == SMF.MIDIEventType.note_on:
		var note_data: Dictionary = notes.get(event.note)
  
		if note_data:
			var note = NOTE_SCENE.instantiate()
			note.global_position = note_data["button"].global_position + BUTTON_SPAWN_OFFSET - Vector2(0, NOTE_Y_OFFSET)
			note.texture = note_data["texture"]
			note.speed = NOTE_Y_OFFSET * FALLING_SPEED_SCALE
			note.expected_time = delta_sum + TIMING_OFFSET
			$NotesContainer.add_child(note)
			note_data["queue"].push_back(note)


# Game Node
func _ready() -> void:
	$MidiPlayer.play()

func _process(delta: float) -> void:
	delta_sum += delta
	_check_input()
	_check_miss()
 
	if delta_sum >= TIMING_OFFSET and not $AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
 
func _check_input():
	for note_data in notes.values():
		if Input.is_action_just_pressed(note_data["key"]):
			_check_note_hit(note_data)

func _check_note_hit(note_data: Dictionary) -> void:
	if not note_data["queue"].is_empty():
		var next_note: Node2D = note_data["queue"].front()
		if next_note.test_hit(delta_sum):
			note_data["queue"].pop_front().hit(delta_sum)
		else:
			Highscore.update_points(Highscore.TimingJudgement.WHAT)
	else:
		Highscore.update_points(Highscore.TimingJudgement.WHAT)

func _check_miss() -> void:
	for note_data in notes.values():
		if not note_data["queue"].is_empty():
			if note_data["queue"].front().test_miss(delta_sum):
				note_data["queue"].pop_front().miss()
