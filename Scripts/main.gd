extends Node2D

@export var ennemi1_scene: PackedScene
@export var bouclier_scene: PackedScene
@export var missile_buff_scene: PackedScene
@export var pioupiou_buff_scene: PackedScene
@export var laser_buff_scene: PackedScene
@export var coeur_buff_scene: PackedScene
@export var speed_buff_scene: PackedScene
var enemy_scenes = {}
var buff_scenes = {}

func _ready() -> void:
	enemy_scenes = {
	"Ennemi1" : ennemi1_scene,
}
	buff_scenes = {
		"Bouclier" : bouclier_scene,
		"Missile" : missile_buff_scene,
		"Pioupiou" : pioupiou_buff_scene,
		"Laser" : laser_buff_scene,
		"Coeur" : coeur_buff_scene,
		"Speed" : speed_buff_scene,
	}
	get_tree().call_group('UI', 'set_health', $Player.lives)

func buff_generator():
	var rng = randi_range(0,100)
	if rng <= 100.0/buff_scenes.size()*1 :
		summon_buff("Bouclier")
	elif rng <= 100.0/buff_scenes.size()*2 :
		summon_buff("Missile")
	elif rng <= 100.0/buff_scenes.size()*3 :
		summon_buff("Pioupiou")
	elif rng <= 100.0/buff_scenes.size()*4 :
		summon_buff("Laser")
	elif rng <= 100.0/buff_scenes.size()*5 :
		summon_buff("Speed")
	else :
		summon_buff("Coeur")


func get_spawnpoint():
	var vect = Vector2(randi() % 650 + 40, -60)
	#print(vect)
	return vect
	
func summon_enemy(nom: String, type: int = -1):
	if nom in enemy_scenes:
		var enemy = enemy_scenes[nom].instantiate()
		enemy.health += (5*Global.Wave)
		if type == -1:
			var rng = randi_range(0,100)
			if Global.Wave <= 5:
				rng = 10
			if rng <= max(40, 60 - (Global.Wave-1) * 0.5) :
				type = 0
			elif rng <= max(65, 80 - (Global.Wave-1) * 0.5) :
				type = 1
			elif rng <= 100 :
				type = 2
		match type:
			1:
				#"Fast"
				enemy.health += (enemy.health/8)
				enemy.speed += 100
				enemy.bonus = 15
				enemy.scale = Vector2(0.9,0.9)
			2:
				#"Tank"
				enemy.health += 50 * Global.Wave
				enemy.speed = 50
				enemy.bonus = 40
				enemy.scale = Vector2(1.2,1.2)
			3:
				#"Boss"
				enemy.health += 100 * Global.Wave
				enemy.speed = 25
				enemy.bonus = 100
				enemy.scale = Vector2(1.5,1.5)
		
		enemy.position = get_spawnpoint()
		$Ennemis.add_child(enemy)
	else:
		push_error("Enemy type '" + nom + "' not found!")

func summon_buff(nom: String):
	if nom in buff_scenes:
		var buff = buff_scenes[nom].instantiate()
		buff.position = get_spawnpoint()
		$Buffs.add_child(buff)
	else:
		push_error("Buff type '" + nom + "' not found!")
	
	
func get_spawn_delay() -> float:
	return max(0.5, 4.0 - Global.Wave * 0.1)  # Plus difficile = plus rapide

func start_wave() -> void:
	$UI/ScoreContainer/Wave.text = "Wave : " + str(Global.Wave)
	for i in Global.Wave:
		if i < Global.Wave-1:	
			summon_enemy("Ennemi1")
			await get_tree().create_timer(get_spawn_delay()).timeout
		else :
			if Global.Wave % 5 == 0:
				summon_enemy("Ennemi1",3)
			else:
				summon_enemy("Ennemi1")
			Global.Wave += 1
			await get_tree().create_timer(5.0).timeout
			start_wave()
