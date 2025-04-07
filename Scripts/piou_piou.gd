extends Area2D

@export var speed = 600
@export var damage = 20
@export var direction = "straight"

func _process(delta):
	rotation += 10*delta
	
	if direction == "right":
		position.y -= speed * delta / 2
		position.x += speed * delta / 2
	elif direction == "left":
		position.y -= speed * delta / 2
		position.x -= speed * delta / 2
	else:
		position.y -= speed * delta
		
	if position.y < -10:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Ennemis":
		Global.hit(area,damage)
		queue_free()
