extends Area2D

@export var speed = 0
@export var damage = 50
@export var time = 4
var player: CharacterBody2D
var targets_in_contact: Array = []


func _ready():
	player = get_tree().current_scene.get_node("Player")
	start_disappear_timer()

func _process(delta):
	position = player.get_node("Laser").global_position
	for target in targets_in_contact:
		Global.hit(target,damage*delta)
		#print(target.health)

func start_disappear_timer():
	await Global.wait(time)
	queue_free()
	player.laser_level = 0

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Ennemis":
		targets_in_contact.append(area)

func _on_area_exited(area):
	targets_in_contact.erase(area)
