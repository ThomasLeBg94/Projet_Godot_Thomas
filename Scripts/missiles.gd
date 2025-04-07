extends Area2D

@export var speed = 400
@export var damage = 25

func _process(delta):
	position.y -= speed * delta
	if position.y < -10:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Ennemis":
		Global.hit(area,damage)
		queue_free()
