extends Control

@export var level_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect/CenterContainer/VBoxContainer/Continue.pressed.connect(_continue)
	$ColorRect/CenterContainer/VBoxContainer/Quit.pressed.connect(_quit)
	Global.score = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_continue()
	if Input.is_action_just_pressed("ui_cancel"):
		_quit()

func _continue():
	get_tree().change_scene_to_packed(level_scene)

func _quit():
	get_tree().quit()
