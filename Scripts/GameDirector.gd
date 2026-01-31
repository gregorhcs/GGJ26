extends Control

@export var AvatarControl : Node
@export var WalkableArea : Node

@export var ScreenUIContainer : TextureRect
@export var Screens : Array[Texture2D]

var CurrentScreen = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_screen(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_background_image_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		AvatarControl.move_to(event.position)


func _update_screen(new_screen: int) -> void:
	if new_screen != CurrentScreen:
		ScreenUIContainer.texture = Screens[CurrentScreen]
		CurrentScreen = new_screen

func _on_sc_level_change_left_triggered() -> void:
	_update_screen((CurrentScreen  - 1) % Screens.size())

func _on_sc_level_change_right_triggered() -> void:
	_update_screen((CurrentScreen + 1) % Screens.size())
