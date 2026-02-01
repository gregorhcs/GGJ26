extends Control

@export var Mask: TextureRect
@export var Screens : Array[PackedScene]

var CurrentScreen = 0;
var CurrentLevelInstance: Node;

signal level_changed(new_level);
signal tried_pass_level_array_bound;

func _ready() -> void:
	if get_children().size() > 0:
		remove_child(get_child(0))
	var CurrentLevelInstance = Screens[0].instantiate()
	add_child(CurrentLevelInstance)
	Mask.texture = CurrentLevelInstance.Mask
	
func set_screen(new_screen: int) -> void:
	_update_screen(new_screen)
	
func next_screen() -> void:
	_update_screen(CurrentScreen + 1)

func previous_screen() -> void:
	_update_screen(CurrentScreen - 1)

func _update_screen(new_screen: int) -> void:
	if new_screen == Screens.size():
		tried_pass_level_array_bound.emit()
		return
	print("New Screen: ", new_screen)
	if new_screen != CurrentScreen:
		if get_children().size() > 0:
			remove_child(get_child(0))
		CurrentLevelInstance = Screens[new_screen].instantiate()
		add_child(CurrentLevelInstance)
		Mask.texture = CurrentLevelInstance.Mask
		CurrentScreen = new_screen
		level_changed.emit(CurrentLevelInstance)
