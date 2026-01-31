extends Node

@export var TriggerButton : Button

signal triggered;

func _on_button_pressed() -> void:
	emit_signal("triggered")

func _on_button_mouse_entered() -> void:
	pass

func _on_button_mouse_exited() -> void:
	pass
