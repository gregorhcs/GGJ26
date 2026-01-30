extends Node

@export var AvatarControl : Node

@export var ScreenUIContainer : TextureRect
@export var Screens : Array[Texture2D]

var CurrentScreen = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_screen(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event):
	if event.is_action_pressed("world_act_at"):
		AvatarControl.move_to(event.position)


func _on_button_next_pressed() -> void:
	_update_screen((CurrentScreen + 1) % Screens.size())

func _update_screen(new_screen: int) -> void:
	if new_screen != CurrentScreen:
		ScreenUIContainer.texture = Screens[CurrentScreen]
		CurrentScreen = new_screen
