extends CanvasLayer

static var image = load("res://Images/Heart.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_health(amount):
	var n = amount
	# remove all children
	for child in $PlayerContainer/HeartContainer.get_children():
		child.free()
	# create new children amount is set by health
	if amount >= 4:
		n = 4
	for i in n:
		var text_rect = TextureRect.new()
		text_rect.texture = image
		text_rect.name = "TextureRect" + str(i)
		text_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		text_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		$PlayerContainer/HeartContainer.add_child(text_rect,true)
		
	if amount > 4:
		var last_heart = $PlayerContainer/HeartContainer.get_node("TextureRect3")
		var label: Label = last_heart.get_node_or_null("Label")
		if label:
			label.text = "+" + str(amount - n)
		else:
			label = Label.new()
			label.name = "Label"
			label.text = "+" + str(amount - n)
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			label.position = Vector2(4,2)
			last_heart.add_child(label)


func _on_score_timer_timeout() -> void:
	Global.score += 1
	$ScoreContainer/Score.text = "Score : " + str(Global.score)
