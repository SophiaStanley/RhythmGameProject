extends Button
class_name InputRemapButton

@export var action: String # the name of the action we will be changing
@export var action_event_index: int = 0 # the index for the key


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_mode = true;
	_toggled(false)

func _toggled(toggled_on: bool) -> void:
	if !action or !InputMap.has_action(action): # if the action doesn't exist
		return
	
	if toggled_on:
		text = "Input..."
		return
	
	if action_event_index >= InputMap.action_get_events(action).size():
		text = "Unassigned"
		return
	
	var input = InputMap.action_get_events(action)[action_event_index]
	if input is InputEventKey:
		if input.physical_keycode != 0:
			text = OS.get_keycode_string(input.physical_keycode)
		else:
			text = OS.get_keycode_string(input.keycode)

func _unhandled_input(event: InputEvent) -> void:
	if !InputMap.has_action(action) or !is_pressed(): # if the action doesn't exist or if nothing is pressed
		return
	
	if event.is_pressed() and (event is InputEventKey): # if a key on the keyboard is pressed
		var action_events_list = InputMap.action_get_events(action)
		if action_event_index < action_events_list.size(): 
			InputMap.action_erase_event(action, action_events_list[action_event_index])
		
		InputMap.action_add_event(action, event)
		action_event_index = InputMap.action_get_events(action).size()-1
		button_pressed = false
		release_focus()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed(): # turning off toggle if a different one is clicked
		button_pressed = false
		release_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://title_screen.tscn")
