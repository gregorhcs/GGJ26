extends Node

const Date = preload("res://Scripts/Enums.gd")

@export var TriggerButton : Button
@export var TextToSay: Dictionary[GameEnums.Command, String] = { 
	GameEnums.Command.LOOK : "", 
	GameEnums.Command.TALK : "", 
	GameEnums.Command.WALK : "" }
@export var NarratorTextToSay: Dictionary[GameEnums.Command, String] = { 
	GameEnums.Command.LOOK : "", 
	GameEnums.Command.TALK : "", 
	GameEnums.Command.WALK : "" }
@export var Insanity: Dictionary[GameEnums.Command, int] = { 
	GameEnums.Command.LOOK : 1, 
	GameEnums.Command.TALK : 4, 
	GameEnums.Command.WALK : 2 }
@export var ChangeLevelLeft : bool
@export var ChangeLevelRight : bool

signal is_available(node, command);
signal is_unavailable(node,command)
signal request(node,command);

func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				request.emit(self, GameEnums.Command.LOOK)
			MOUSE_BUTTON_RIGHT:
				request.emit(self, GameEnums.Command.WALK)
			MOUSE_BUTTON_MIDDLE:
				request.emit(self, GameEnums.Command.TALK)

func _on_button_mouse_entered() -> void:
	for command_name in GameEnums.Command.keys():
		var command_value = GameEnums.Command[command_name]
		if !TextToSay[command_value].is_empty():
			is_available.emit(self, command_value)


func _on_button_mouse_exited() -> void:
	for command_name in GameEnums.Command.keys():
		var command_value = GameEnums.Command[command_name]
		if !TextToSay[command_value].is_empty():
			is_unavailable.emit(self, command_value)
