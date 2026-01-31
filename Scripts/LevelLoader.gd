extends Control

@export var Mask: TextureRect
@export var Screens : Array[PackedScene]

var CurrentScreen = 0;

signal level_changed(new_level);

func _ready() -> void:
	if get_children().size() > 0:
		remove_child(get_child(0))
	var level_instance = Screens[0].instantiate()
	add_child(level_instance)
	Mask.texture = level_instance.Mask
	
func next_screen() -> void:
	_update_screen((CurrentScreen + 1) % Screens.size())

func previous_screen() -> void:
	_update_screen((CurrentScreen - 1) % Screens.size())

func _update_screen(new_screen: int) -> void:
	if new_screen != CurrentScreen:
		if get_children().size() > 0:
			remove_child(get_child(0))
		var level_instance = Screens[new_screen].instantiate()
		add_child(level_instance)
		Mask.texture = level_instance.Mask
		CurrentScreen = new_screen
		level_changed.emit(level_instance)
