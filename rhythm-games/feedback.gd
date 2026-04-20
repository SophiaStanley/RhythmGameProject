extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	
	tween.tween_property(self, "modulate", Color(1,1,1,0.0), 0.5)
	tween.tween_callback(queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func change_text(text) -> void:
	$Label.text = (text)
