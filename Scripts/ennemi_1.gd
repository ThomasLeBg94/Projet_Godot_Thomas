extends Area2D

@export var speed = 100
@export var health = 100
@export var bonus = 10

func _ready() -> void:
	update_label()

func _physics_process(delta):
	position += Vector2(0, 1) * speed * delta
	if position.y >= 1000:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		#for child in get_tree().current_scene.get_node("Ennemis").get_children():
			#child.queue_free()
		body.position = Vector2(360,880)
		body.set_iframe(2)
		body.lives -= 1
		get_tree().call_group('UI', 'set_health', body.lives)

func update_label():
	$Label.text = str(health)
