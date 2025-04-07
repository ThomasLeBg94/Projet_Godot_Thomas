extends CharacterBody2D

@export var speed = 300
@export var lives = 6
@export var iframe = false

@export var pioupiou_level = 1
@export var missile_level = 0
@export var laser_level = 0
@export var bouclier_level = 0

@export var pioupiou_scene: PackedScene
@export var missile_scene: PackedScene
@export var laser_scene: PackedScene

@onready var PiouPiouCooldown: Timer = $PiouPiouCooldown
@onready var MissilesCooldown: Timer = $MissilesCooldown
@onready var BouclierCooldown: Timer = $BouclierCooldown
@onready var LaserCooldown: Timer = $LaserCooldown
@onready var DodgeCooldown: Timer = $DodgeCooldown

func _ready() -> void:
	set_iframe(2)

func _physics_process(_delta):
	var dir = Vector2.ZERO
	if Input.is_action_pressed("Droite"):
		dir.x += 1
	if Input.is_action_pressed("Gauche"):
		dir.x -= 1
	if Input.is_action_pressed("Bas"):
		dir.y += 1
	if Input.is_action_pressed("Haut"):
		dir.y -= 1
	#if Input.is_action_just_pressed("Dodge"):
		#if iframe == false:
			#set_iframe(3)

	velocity = dir.normalized() * speed
	move_and_slide()

func _process(_delta):
	if lives <= 0:
		update_HighScore()
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
	if iframe == true:
		if $AnimatedSprite2D.animation != "IFrame" or $AnimatedSprite2D.get_playing_speed() == 0:
			$AnimatedSprite2D.play("IFrame")
	else:
		if $AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.stop()
	
	if Input.is_action_pressed("PiouPiou") and PiouPiouCooldown.is_stopped():
		PiouPiouCooldown.start()
		shoot_PiouPiou()
	if Input.is_action_pressed("Missiles") and MissilesCooldown.is_stopped() and missile_level >= 1:
		MissilesCooldown.start()
		shoot_Missiles()
	if Input.is_action_just_pressed("Laser") and LaserCooldown.is_stopped() and laser_level >= 1:
		LaserCooldown.start()
		shoot_Laser()
		laser_level = 0
		get_tree().current_scene.get_node("UI").get_node("PlayerContainer").get_node("BuffContainer").get_node("LaserLabel").text = str(laser_level)
	if Input.is_action_just_pressed("Dodge") and BouclierCooldown.is_stopped() and bouclier_level >= 1 and iframe == false:
		BouclierCooldown.start()
		set_iframe(5*bouclier_level)
		bouclier_level = 0
		get_tree().current_scene.get_node("UI").get_node("PlayerContainer").get_node("BuffContainer").get_node("BouclierLabel").text = str(bouclier_level)

func shoot_PiouPiou():
	var bullet = pioupiou_scene.instantiate()
	bullet.damage *= pioupiou_level
	bullet.position = $PiouPiou.global_position
	if pioupiou_level >= 2 :
		var bullet2 = pioupiou_scene.instantiate()
		bullet2.damage *= pioupiou_level
		bullet2.position = $PiouPiou.global_position
		bullet2.direction = "left"
		var bullet3 = pioupiou_scene.instantiate()
		bullet3.damage *= pioupiou_level
		bullet3.position = $PiouPiou.global_position
		bullet3.direction = "right"
		get_tree().current_scene.get_node("Projectiles").add_child(bullet2)
		get_tree().current_scene.get_node("Projectiles").add_child(bullet3)
	get_tree().current_scene.get_node("Projectiles").add_child(bullet)

func shoot_Missiles():
	var missile1 = missile_scene.instantiate()
	var missile2 = missile_scene.instantiate()
	missile1.damage *= missile_level
	missile2.damage *= missile_level
	missile1.position = $Missile1.global_position
	missile2.position = $Missile2.global_position
	get_tree().current_scene.get_node("Projectiles").add_child(missile1)
	get_tree().current_scene.get_node("Projectiles").add_child(missile2)

func shoot_Laser():
	var laser = laser_scene.instantiate()
	laser.damage *= laser_level
	laser.scale.x += 0.25 * (laser_level-1)
	laser.position = $Laser.global_position
	get_tree().current_scene.get_node("Projectiles").add_child(laser)

func set_iframe(time):
	self.iframe = true
	self.set_collision_layer_value(1,false)
	await Global.wait(time)
	self.set_collision_layer_value(1,true)
	self.iframe = false

func update_HighScore():
	if Global.score > Global.HighScore:
		Global.HighScore = Global.score
