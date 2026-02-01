extends Node2D

@export var AnimatedAvatarSprite: AnimatedSprite2D
@export var SpeechText: RichTextLabel

var current_goal = Vector2(0, 0)
var current_callback: Callable
var is_moving = false

func move_to(position: Vector2, callback: Callable) -> void:
	current_goal = position
	current_callback = callback

func set_text(text: String) -> void:
	SpeechText.text = text

func clear_text() -> void:
	SpeechText.text = "";

func _ready() -> void:
	current_goal = position
	clear_text()

func _process(delta: float) -> void:
	var delta_to_goal = current_goal - position
	if (current_goal - position).length() > 1.0:
		position += delta * delta_to_goal.normalized() * 100
		is_moving = true
		if AnimatedAvatarSprite.animation != "run":
			AnimatedAvatarSprite.flip_h = delta_to_goal.x > 0
			AnimatedAvatarSprite.play("run")
	else:
		if is_moving and current_callback.is_valid():
			current_callback.call()
		is_moving = false
		if AnimatedAvatarSprite.animation != "default":
			AnimatedAvatarSprite.play("default")
