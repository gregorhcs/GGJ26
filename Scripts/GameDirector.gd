extends Control

@export var AvatarControl : Node
@export var Mask : TextureRect

@export var ScreenUIContainer : TextureRect
@export var Screens : Array[Texture2D]
@export var CommandButtons : Dictionary[GameEnums.Command, Button]

const Date = preload("res://Scripts/Enums.gd")

var CurrentScreen = 0;
var CurrentInsanity = 0;

func increase_insanity(amount: int) -> void:
	CurrentInsanity += amount;
	Mask.material.set_shader_parameter("CRACK_profile", CurrentInsanity / 100.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_screen(0)
	for node in get_tree().get_nodes_in_group("interactables"):
		node.is_available.connect(_on_interactable_available)
		node.is_unavailable.connect(_on_interactable_unavailable)
		node.request.connect(_on_interactable_request)
		
func _on_interactable_available(node, command: GameEnums.Command):
	print("Interactable Available:", node.name, " - ", command)
	CommandButtons[command].add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
		
func _on_interactable_unavailable(node, command: GameEnums.Command):
	print("Interactable Unavailable:", node.name, " - ", command)
	CommandButtons[command].add_theme_color_override("font_color", Color("80ca51"))
		
func _on_interactable_request(node, command: GameEnums.Command):
	print("Interactable Request:", node.name, " - ", command)
			
	if command == GameEnums.Command.WALK:
		if node.ChangeLevelLeft:
			_update_screen((CurrentScreen - 1) % Screens.size())
		elif node.ChangeLevelRight:
			_update_screen((CurrentScreen + 1) % Screens.size())
		else:
			AvatarControl.move_to(node.position + node.pivot_offset, func() : pass)
		
	if !node.TextToSay[command].is_empty():
		AvatarControl.set_text(node.TextToSay[command])
	
	increase_insanity(node.Insanity[command])
	
func _on_background_image_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		AvatarControl.move_to(event.position, func(): pass)
		AvatarControl.set_text("Okay..")
		increase_insanity(1)

func _update_screen(new_screen: int) -> void:
	if new_screen != CurrentScreen:
		ScreenUIContainer.texture = Screens[CurrentScreen]
		CurrentScreen = new_screen
		increase_insanity(3)
