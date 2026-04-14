# tutorial used for code:
# https://medium.com/@sergejmoor01/building-a-rhythm-game-in-godot-part-1-synchronizing-gameplay-with-music-258b0bcab458
extends Node2D

var stamina := 20

var song1 = "res://assets/midi/tutorial.mid"
var song2 = "res://assets/midi/test2.mid"

# midiplayer and timer for playing and changing, hud for updating
@onready var midiPlayer = $MidiPlayer
@onready var timer = $Timer
@onready var hud = $HUD

# AnimationPlayers for each character
@onready var irisAnimation = $Iris/IrisAnimation
@onready var gwynAnimation = $Gwyn/GwynAnimation
@onready var elodieAnimation = $Elodie/ElodieAnimation
@onready var enidAnimation = $Enid/EnidAnimation
@onready var aceAnimation = $Ace/AceAnimation

# the time that has passed since the game scene started. used for tracking time for syncing music
var delta_sum := 0.0
const FALLING_SPEED_SCALE := 0.5
const TIMING_OFFSET := (1.0/FALLING_SPEED_SCALE)

const BUTTON_SPAWN_OFFSET := Vector2(32, 32)
const NOTE_Y_OFFSET := 400
# Each note in the MIDI file represents a note in the game. This dictionary is used to link them together
# So it should play properly.
const NOTE_SCENE: PackedScene = preload("res://note.tscn")

@onready var notes: Dictionary = {
	36: {
		"key": "Button1",
		"button": get_node("Buttons/Button1"),
		"texture": preload("res://assets/sprites/Note1.png"),
		"queue": []
	},
	38: {
		"key": "Button2",
		"button": get_node("Buttons/Button2"),
		"texture": preload("res://assets/sprites/Note2.png"),
		"queue": []
	},
	40: {
		"key": "Button3",
		"button": get_node("Buttons/Button3"),
		"texture": preload("res://assets/sprites/Note3.png"),
		"queue": []
	},
	42: {
		"key": "Button4",
		"button": get_node("Buttons/Button4"),
		"texture": preload("res://assets/sprites/Note4.png"),
		"queue": []
	}
}


# Game Node 
func _on_midi_player_midi_event(_channel: Variant, event: Variant) -> void:
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
	if (Globals.song_choice == 1):
		midiPlayer.file = song1
		timer.start(35.0)
		irisAnimation.play("Iris/Song1")
		gwynAnimation.play("Gwyn/GwynSong1")
		elodieAnimation.play("Elodie/Song1")
		enidAnimation.play("Enid/Song1")
		aceAnimation.play("Ace/Song1")
	elif (Globals.song_choice == 2):
		midiPlayer.file = song2
		timer.start(29.0)
		irisAnimation.play("Iris/Song2")
		gwynAnimation.play("Gwyn/GwynSong2")
	midiPlayer.play()

func _process(delta: float) -> void:
	hud.update_stamina(stamina)
	hud.update_score(Highscore.displayed_points)
	hud.update_combo(Combo.combo)
	delta_sum += delta
	_check_input()
	_check_miss()
	_check_loss()
	
	if (Globals.song_choice == 1):
		#checking if stamina is 0 cause otherwise it keeps playing and stopping every frame after stamina reaches 0
		if delta_sum >= TIMING_OFFSET and not $AudioStreamPlayer.playing and stamina > 0 and $AudioStreamPlayer.is_inside_tree():
			$AudioStreamPlayer.play()
			stamina = 20 # resetting stamina to max when the song starts
	elif (Globals.song_choice == 2):
		if delta_sum >= TIMING_OFFSET and not $Sogn2.playing and stamina > 0 and $Sogn2.is_inside_tree():
			$Sogn2.play()
	

func _check_input():
		
	for note_data in notes.values():
		if Input.is_action_just_pressed(note_data["key"]):
			_check_note_hit(note_data)

func _check_note_hit(note_data: Dictionary) -> void:
	if not note_data["queue"].is_empty():
		var next_note: Node2D = note_data["queue"].front()
		if next_note.test_hit(delta_sum):
			note_data["queue"].pop_front().hit(delta_sum)
			if Combo.combo % 10 == 0 and not Combo.combo == 0:
				stamina +=2
		else:
			Highscore.update_points(Highscore.TimingJudgement.WHAT)
			stamina -= 2
	else:
		Highscore.update_points(Highscore.TimingJudgement.WHAT)
		stamina -= 2

func _check_miss() -> void:
	for note_data in notes.values():
		if not note_data["queue"].is_empty():
			if note_data["queue"].front().test_miss(delta_sum):
				note_data["queue"].pop_front().miss()
				stamina -= 2

func _check_loss() -> void:
	if stamina <= 0:
		game_over()

func game_over() -> void:
	$AudioStreamPlayer.stop()
	midiPlayer.stop()
	get_tree().change_scene_to_file("res://end_screen.tscn")

func _on_timer_timeout() -> void:
	to_results()

func to_results() -> void:
	get_tree().change_scene_to_file("res://end_screen.tscn")
