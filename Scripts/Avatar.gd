extends Node2D

@export var AnimatedAvatarSprite: AnimatedSprite2D
@export var SpeechText: RichTextLabel

var current_goal = Vector2(0, 0)
var is_moving = false

func move_to(position: Vector2) -> void:
	current_goal = position
	set_text("Okay..")

func set_text(text: String) -> void:
	SpeechText.text = text
	await get_tree().create_timer(text.length() * 0.2).timeout
	clear_text()

func clear_text() -> void:
	SpeechText.text = "";

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_goal = position
	clear_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var delta_to_goal = current_goal - position
	
	if position != current_goal:
		position += delta * delta_to_goal.normalized() * 100
		is_moving = true
		AnimatedAvatarSprite.flip_h = delta_to_goal.x > 0
	else:
		is_moving = false
