extends Node
var score := 0
var HighScore := 0
var Wave := 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	
func hit(target:Area2D,damage:float):
	if target.health:
		target.health -= damage
		target.update_label()
		if target.health <= 0:
			Global.score += target.bonus
			target.queue_free()
