# tutorial used for code:
# https://medium.com/@sergejmoor01/building-a-rhythm-game-in-godot-part-1-synchronizing-gameplay-with-music-258b0bcab458
extends Node2D

# the time that has passed since the game scene started. used for tracking time for syncing music
var delta_sum := 0.0
const TIMING_OFFSET := (1.0/FALLING_SPEED_SCALE)

const BUTTON_SPAWN_OFFSET := Vector2(16, 16)
const NOTE_Y_OFFSET := 400
const FALLING_SPEED_SCALE := 0.5

# Game Node 
func _on_midi_player_midi_event(channel: Variant, event: Variant) -> void:
 print(event.type)
 if event.type == SMF.MIDIEventType.note_on:
  var note_data: Dictionary = notes.get(event.note)
  
  if note_data:
   var note = NOTE_SCENE.instantiate()
   note.global_position = note_data["button"].global_position + BUTTON_SPAWN_OFFSET - Vector2(0, NOTE_Y_OFFSET)
   note.texture = note_data["texture"]
   note.speed = NOTE_Y_OFFSET * FALLING_SPEED_SCALE
   $NotesContainer.add_child(note)
  print(event.note)


# Game Node
func _ready() -> void:
 $MidiPlayer.play()

func _process(delta: float) -> void:
 delta_sum += delta
 
 if delta_sum >= TIMING_OFFSET and not $AudioStreamPlayer.playing:
  $AudioStreamPlayer.play()
 
func _input(event):
 if event is InputEventKey and event.pressed:
  if event.keycode == KEY_T:
   print("T was pressed")


# Each note in the MIDI file represents a note in the game. This dictionary is used to link them together
# So it should play properly.
const NOTE_SCENE: PackedScene = preload("res://note.tscn")

@onready var notes: Dictionary = {
 36: {
  "key": "ui_up",
  "button": get_node("Buttons/UpButton"),
  "texture": preload("res://assets/sprites/arrow_up_note.png")
 },
 38: {
  "key": "ui_down",
  "button": get_node("Buttons/DownButton"),
  "texture": preload("res://assets/sprites/arrow_down_note.png")
 },
 40: {
  "key": "ui_left",
  "button": get_node("Buttons/LeftButton"),
  "texture": preload("res://assets/sprites/arrow_left_note.png")
 },
 42: {
  "key": "ui_right",
  "button": get_node("Buttons/RightButton"),
  "texture": preload("res://assets/sprites/arrow_right_note.png")
 }
}
