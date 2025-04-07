extends Area2D

@export var speed = 65

func _physics_process(delta):
	position += Vector2(0, 1) * speed * delta
	if position.y >= 1000:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.missile_level += 1
		var lab = get_tree().current_scene.get_node("UI").get_node("PlayerContainer").get_node("BuffContainer").get_node("MissileLabel")
		lab.text = str(body.missile_level)
		queue_free()
