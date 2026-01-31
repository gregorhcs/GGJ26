extends Control

@export var LevelLoader : Node
@export var AvatarControl : Node
@export var Mask : TextureRect
@export var CommandButtons : Dictionary[GameEnums.Command, RichTextLabel]
@export var NarratorTextLabel : RichTextLabel
@export var CrackAudioPlayer : AudioStreamPlayer

const Date = preload("res://Scripts/Enums.gd")

var CurrentInsanity = 0;
var CurrentInsanityPhase = 0;

func set_narrator_text(text: String) -> void:
	if !text.is_empty():
		NarratorTextLabel.text = text

func increase_insanity(amount: int) -> void:
	CurrentInsanity += amount;
	Mask.material.set_shader_parameter("CRACK_profile", CurrentInsanity / 100.0)
	if CurrentInsanity / 10 > CurrentInsanityPhase:
		CurrentInsanityPhase = CurrentInsanity / 10
		CrackAudioPlayer.pitch_scale = 0.5 + randf()
		CrackAudioPlayer.play(0.0)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_tree().get_nodes_in_group("interactables"):
		node.is_available.connect(_on_interactable_available)
		node.is_unavailable.connect(_on_interactable_unavailable)
		node.request.connect(_on_interactable_request)
		
func _on_interactable_available(node, command: GameEnums.Command):
	print("Interactable Available:", node.name, " - ", command)
	CommandButtons[command].add_theme_color_override("default_color", Color(1.0, 1.0, 1.0))
		
func _on_interactable_unavailable(node, command: GameEnums.Command):
	print("Interactable Unavailable:", node.name, " - ", command)
	CommandButtons[command].add_theme_color_override("default_color", Color("80ca51"))
		
func _on_interactable_request(node, command: GameEnums.Command):
	print("Interactable Request:", node.name, " - ", command)
			
	if command == GameEnums.Command.WALK:
		if node.ChangeLevelLeft:
			LevelLoader.previous_screen()
		elif node.ChangeLevelRight:
			LevelLoader.next_screen()
		else:
			AvatarControl.move_to(node.position + node.pivot_offset, func() : pass)
		
	if !node.TextToSay[command].is_empty():
		AvatarControl.set_text(node.TextToSay[command])
	if !node.NarratorTextToSay[command].is_empty():
		set_narrator_text(node.NarratorTextToSay[command])
	
	increase_insanity(node.Insanity[command])
	
func _on_background_image_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		AvatarControl.move_to(event.position, func(): pass)
		AvatarControl.set_text("Okay..")
		increase_insanity(1)

func get_all_descendants(node: Node) -> Array:
	var result := []
	for child in node.get_children():
		result.append(child)
		result += get_all_descendants(child)
	return result


func _on_level_loader_level_changed(new_level) -> void:
	increase_insanity(3)
	for node in get_all_descendants(new_level):
		if node.is_in_group("interactables"):
			node.is_available.connect(_on_interactable_available)
			node.is_unavailable.connect(_on_interactable_unavailable)
			node.request.connect(_on_interactable_request)
